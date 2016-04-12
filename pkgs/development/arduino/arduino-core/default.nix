{ stdenv, fetchFromGitHub, jdk, jre, ant, coreutils, gnugrep, file, unzip
, libusb, readline, ncurses, zlib
, withGui ? true, gtk2 ? null
}:

assert withGui -> gtk2 != null;

stdenv.mkDerivation rec {

  version = "1.6.5-r3";
  name = "arduino${stdenv.lib.optionalString (withGui == false) "-core"}-${version}";

  src = fetchFromGitHub {
    owner = "arduino";
    repo = "Arduino";
    rev = "${version}";
    sha256 = "1shfc09hpq9nzmb114v0bvx26zwl7d5mf5ijyhc45gzhda4670r6";
  };

  buildInputs = [ jdk ant file unzip ];

  buildPhase = ''
    cd ./arduino-core && ant
    cd ../build && ant 
    cd ..
  '';

  installPhase = ''
    mkdir -p $out/share/arduino
    cp -r ./build/linux/work/* "$out/share/arduino/"
    echo ${version} > $out/share/arduino/lib/version.txt

    ${stdenv.lib.optionalString withGui ''
      mkdir -p "$out/bin"
      sed -i -e "s|^JAVA=java|JAVA=${jdk}/bin/java|" "$out/share/arduino/arduino"
      sed -i -e "s|^LD_LIBRARY_PATH=|LD_LIBRARY_PATH=${gtk2}/lib:|" "$out/share/arduino/arduino"
      ln -sr "$out/share/arduino/arduino" "$out/bin/arduino"
    ''}

    ln -s "${ncurses}/lib/libncursesw.so.5" "$out/share/arduino/hardware/tools/avr/lib/libtinfo.so.5"

    # Fixup "/lib64/ld-linux-x86-64.so.2" like references in ELF executables.
    echo "running patchelf on prebuilt binaries:"
    find "$out" | while read filepath; do
        if file "$filepath" | grep -q "ELF.*executable"; then
            # skip target firmware files
            if echo "$filepath" | grep -q "\.elf$"; then
                continue
            fi
            echo "setting interpreter $(cat "$NIX_CC"/nix-support/dynamic-linker) in $filepath"
            patchelf --set-interpreter "$(cat "$NIX_CC"/nix-support/dynamic-linker)" "$filepath"
            test $? -eq 0 || { echo "patchelf failed to process $filepath"; exit 1; }
        fi
    done

    patchelf --set-rpath ${stdenv.lib.makeLibraryPath [ stdenv.cc.cc ]} \
             "$out/share/arduino/lib/libastylej.so"

    find "$out/share/arduino/hardware/tools/avr/bin/" -type f | while read filepath; do
      if file "$filepath" | grep -q "ELF.*executable"; then
        echo "Setting rpath for $filepath"
        patchelf --set-rpath ${stdenv.lib.makeLibraryPath [ zlib libusb readline ncurses "$out/share/arduino/hardware/tools/avr/" ]} "$filepath"
      fi
    done
    find "$out/share/arduino/hardware/tools/avr/avr/bin/" -type f | while read filepath; do
      if file "$filepath" | grep -q "ELF.*executable"; then
        echo "Setting rpath for $filepath"
        patchelf --set-rpath ${stdenv.lib.makeLibraryPath [ zlib ]} "$filepath"
      fi
    done
  '';

  meta = with stdenv.lib; {
    description = "Open-source electronics prototyping platform";
    homepage = http://arduino.cc/;
    license = stdenv.lib.licenses.gpl2;
    platforms = platforms.all;
    maintainers = with maintainers; [ antono robberer bjornfor ];
  }; 
}
