{ runCommand, glibc, glibc32
}:

let
  nameVersion = builtins.parseDrvName glibc.name;
in
runCommand "${nameVersion.name}-multi-${nameVersion.version}"
  { inherit glibc32;
   glibc64 = glibc;
  }
  ''
    mkdir -p $out
    ln -s $glibc64/* $out/

    rm $out/lib $out/lib64
    mkdir -p $out/lib
    ln -s $glibc64/lib/* $out/lib
    ln -s $glibc32/lib $out/lib/32
    ln -s lib $out/lib64

    # fixing ldd RLTDLIST
    rm $out/bin
    cp -rs $glibc64/bin $out
    chmod u+w $out/bin
    rm $out/bin/ldd
    sed -e "s|^RTLDLIST=.*$|RTLDLIST=\"$out/lib/ld-2.19.so $out/lib/32/ld-linux.so.2\"|g" \
        $glibc64/bin/ldd > $out/bin/ldd
    chmod 555 $out/bin/ldd

    rm $out/include
    cp -rs $glibc32/include $out
    chmod -R u+w $out/include
    cp -rsf $glibc64/include $out
  ''
