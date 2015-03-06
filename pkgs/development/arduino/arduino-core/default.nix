{ stdenv, fetchFromGitHub, jdk, jre, ant, coreutils, gnugrep, file, libusb, unzip,
  readline, zlib, ncurses, withGui ? false, gtk2 ? null
}:

assert withGui -> gtk2 != null;

stdenv.mkDerivation rec {

  version = "1.6.0";
  name = "arduino${stdenv.lib.optionalString (withGui == false) "-core"}";

  src = fetchFromGitHub {
    owner = "arduino";
    repo = "Arduino";
    rev = "${version}";
    sha256 = "1ycbcr16c53lrvqs9yksn80939ivfai28cxd1b29s61fv3xn7ccm";
  };

  buildInputs = [ jdk ant file unzip ];

  buildPhase = ''
    cd ./build && ant 
    cd ..
  '';

  rpath = stdenv.lib.makeLibraryPath [
    zlib
    ncurses
    readline
    stdenv.cc.cc
  ];

  installPhase = ''
    mkdir -p $out/share/arduino
    cp -r ./build/linux/work/* "$out/share/arduino/"
    echo ${version} > $out/share/arduino/lib/version.txt

    ${stdenv.lib.optionalString withGui ''
      mkdir -p "$out/bin"
      sed -i -e "s|^java|${jdk}/bin/java|" "$out/share/arduino/arduino"
      sed -i -e "s|^LD_LIBRARY_PATH=|LD_LIBRARY_PATH=${gtk2}/lib:|" "$out/share/arduino/arduino"
      ln -sr "$out/share/arduino/arduino" "$out/bin/arduino"

      cp -r build/shared/icons $out/share/arduino
      mkdir $out/share/applications
      cp build/linux/dist/arduino.desktop $out/share/applications
      echo "Icon=$out/share/arduino/icons/128x128/apps/arduino.png" >> \
        $out/share/applications/arduino.desktop
    ''}

    # Fixup "/lib64/ld-linux-x86-64.so.2" like references in ELF executables
    # and fix their RPATH header value. 
    echo "running patchelf on prebuilt binaries:"
    find "$out" -type f -executable | while read filepath; do
        if file "$filepath" | grep -q "ELF.*executable"; then
            # skip target firmware files
            if [[ "$filepath" == *.elf ]]; then
                continue
            fi
            echo "Patching $filepath"
            patchelf --set-interpreter "$(cat "$NIX_CC"/nix-support/dynamic-linker)" "$filepath" || \
                { echo "patchelf failed to process $filepath"; exit 1; }
            patchelf --set-rpath ${rpath} "$filepath" || \
                { echo "patchelf failed to set rpath for $filepath"; exit 1; }
            patchelf --shrink-rpath "$filepath" || \
                { echo "patchelf failed to shrink rpath for $filepath"; exit 1; }
        fi
    done
    # HACK: link libncurses to libtinfo which avrdude requires. 
    # Note that out/share/arduino/hardware/tools/avr/lib is added to
    # LD_LIBRARY_PATH by upstream's avrdude wrapper script
    ln -s ${ncurses}/lib/libncurses.so.5 $out/share/arduino/hardware/tools/avr/lib/libtinfo.so.5
    ln -s $out/share/arduino/hardware/tools/avr/lib/libtinfo.so.5 $out/share/arduino/hardware/tools/avr/lib/libtinfo.so
  '';

  meta = with stdenv.lib; {
    description = "Open-source electronics prototyping platform";
    homepage = http://arduino.cc/;
    license = stdenv.lib.licenses.gpl2;
    platforms = platforms.all;
    maintainers = with maintainers; [ antono robberer bjornfor ];
  }; 
}
