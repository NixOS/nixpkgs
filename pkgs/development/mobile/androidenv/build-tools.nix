{stdenv, stdenv_32bit, fetchurl, unzip, zlib_32bit, ncurses_32bit, file, zlib, ncurses}:

stdenv.mkDerivation rec {
  version = "25.0.1";
  name = "android-build-tools-r${version}";
  src = if (stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux")
    then fetchurl {
      url = "https://dl.google.com/android/repository/build-tools_r${version}-linux.zip";
      sha256 = "0kyrazmcckikn6jiz9hwy6nlqjssf95h5iq7alswg1mryl04w6v7";
    }
    else if stdenv.system == "x86_64-darwin" then fetchurl {
      url = "https://dl.google.com/android/repository/build-tools_r${version}-macosx.zip";
      sha256 = "116i5xxbwz229m9z98n6bfkjk2xf3kbhdnqhbbnaagjsjzqdirki";
    }
    else throw "System ${stdenv.system} not supported!";

  buildCommand = ''
    mkdir -p $out/build-tools
    cd $out/build-tools
    unzip $src
    mv android-* ${version}
    
    ${stdenv.lib.optionalString (stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux")
      ''
        cd ${version}

        ln -s ${ncurses.out}/lib/libncurses.so.5 `pwd`/lib64/libtinfo.so.5

        find . -type f -print0 | while IFS= read -r -d "" file
        do
          type=$(file "$file")
          ## Patch 64-bit binaries
          if grep -q "ELF 64-bit" <<< "$type"
          then
            if grep -q "interpreter" <<< "$type"
            then
              patchelf --set-interpreter ${stdenv.cc.libc.out}/lib/ld-linux-x86-64.so.2 "$file"
            fi
            patchelf --set-rpath `pwd`/lib64:${stdenv.cc.cc.lib.out}/lib:${zlib.out}/lib:${ncurses.out}/lib "$file"
          ## Patch 32-bit binaries
          elif grep -q "ELF 32-bit" <<< "$type"
          then
            if grep -q "interpreter" <<< "$type"
            then
              patchelf --set-interpreter ${stdenv_32bit.cc.libc.out}/lib/ld-linux.so.2 "$file"
            fi
            patchelf --set-rpath ${stdenv_32bit.cc.cc.lib.out}/lib:${zlib_32bit.out}/lib:${ncurses_32bit.out}/lib "$file"
          fi
        done
      ''}
      
      patchShebangs .
  '';
  
  buildInputs = [ unzip file ];
}
