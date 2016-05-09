{ stdenv, fetchFromGitHub, jdk, jre, ant, coreutils, gnugrep, file, libusb
, unzip, zlib, readline, ncurses, withGui ? false, gtk2 ? null }:

assert withGui -> gtk2 != null;

stdenv.mkDerivation rec {

  version = "1.6.6";
  name = "arduino${stdenv.lib.optionalString (withGui == false) "-core"}-${version}";

  src = fetchFromGitHub {
    owner = "arduino";
    repo = "Arduino";
    rev = "${version}";
    sha256 = "1gm3sjjs149r2d82ynx25qlg31bbird1zr4x01qi4ybk3gp0268v";
  };

  buildInputs = [ jdk ant file unzip ];

  buildPhase = ''
    cd ./arduino-core && ant 
    cd ../build && ant 
    cd ..
  '';

  libPath = stdenv.lib.makeLibraryPath (builtins.filter (l: l != null) [
    gtk2 stdenv.cc.cc zlib readline libusb ncurses]) + ":$out/lib";

  installPhase = ''
    mkdir -p $out/share/arduino
    cp -r ./build/linux/work/* "$out/share/arduino/"
    echo ${version} > $out/share/arduino/lib/version.txt

    # Hack around lack of libtinfo in NixOS
    mkdir -p $out/lib
    ln -s ${ncurses.out}/lib/libncursesw.so.5 $out/lib/libtinfo.so.5

    ${stdenv.lib.optionalString withGui ''
      mkdir -p "$out/bin"
      sed -i -e "s|^JAVA=.*|JAVA=${jdk}/bin/java|" "$out/share/arduino/arduino"
      sed -i -e "s|^LD_LIBRARY_PATH=|LD_LIBRARY_PATH=${libPath}:|" "$out/share/arduino/arduino"
      ln -sr "$out/share/arduino/arduino" "$out/bin/arduino"
    ''}

    # Fixup "/lib64/ld-linux-x86-64.so.2" like references in ELF executables.
    echo "running patchelf on prebuilt binaries:"
    find "$out" | while read filepath; do
        if file "$filepath" | grep -q "ELF.*executable.*dynamic"; then
            # skip target firmware files
            if echo "$filepath" | grep -q "\.elf$"; then
                continue
            fi
            echo "setting interpreter $(cat "$NIX_CC"/nix-support/dynamic-linker) in $filepath"
            patchelf --set-interpreter "$(cat "$NIX_CC"/nix-support/dynamic-linker)" "$filepath"
            test $? -eq 0 || { echo "patchelf failed to process $filepath"; exit 1; }
        fi
    done

    patchelf --set-rpath ${libPath} \
        "$out/share/arduino/hardware/tools/avr/bin/avrdude_bin"
  '';

  meta = with stdenv.lib; {
    description = "Open-source electronics prototyping platform";
    homepage = http://arduino.cc/;
    license = stdenv.lib.licenses.gpl2;
    platforms = platforms.all;
    maintainers = with maintainers; [ antono robberer bjornfor ];
  }; 
}
