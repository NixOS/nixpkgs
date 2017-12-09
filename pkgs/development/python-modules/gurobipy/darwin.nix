{ stdenv, fetchurl, python, xar, cpio, cctools, insert_dylib }:
assert python.pkgs.isPy27 && python.ucsEncoding == 2;
stdenv.mkDerivation
  { name = "gurobipy-7.0.2";
    src = fetchurl
      { url = "http://packages.gurobi.com/7.0/gurobi7.0.2_mac64.pkg";
        sha256 = "14dpxas6gx02kfb28i0fh68p1z4sbjmwg8hp8h5ch6c701h260mg";
      };
    buildInputs = [ xar cpio cctools insert_dylib ];
    buildCommand =
      ''
        # Unpack
        xar -xf $src
        zcat gurobi*mac64tar.pkg/Payload | cpio -i
        tar xf gurobi*_mac64.tar.gz

        # Install
        cd gurobi*/mac64
        mkdir -p $out/lib/python2.7/site-packages
        mv lib/python2.7/gurobipy $out/lib/python2.7/site-packages
        mv lib/lib*.so $out/lib

        # Fixup
        install_name_tool -change \
          /System/Library/Frameworks/Python.framework/Versions/2.7/Python \
          ${python}/lib/libpython2.7.dylib \
          $out/lib/python2.7/site-packages/gurobipy/gurobipy.so
        install_name_tool -change libgurobi70.so \
          $out/lib/libgurobi70.so \
          $out/lib/python2.7/site-packages/gurobipy/gurobipy.so
        insert_dylib --inplace $out/lib/libaes70.so \
          $out/lib/python2.7/site-packages/gurobipy/gurobipy.so
      '';
  }
