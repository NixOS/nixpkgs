{ fetchurl, python, xar, cpio, cctools, insert_dylib }:
assert python.pkgs.isPy27 && python.ucsEncoding == 2;
python.pkgs.buildPythonPackage
  { pname = "gurobipy";
    version = "7.5.2";
    src = fetchurl
      { url = "http://packages.gurobi.com/7.5/gurobi7.5.2_mac64.pkg";
        sha256 = "10zgn8741x48xjdiknj59x66mwj1azhihi1j5a1ajxi2n5fsak2h";
      };
    buildInputs = [ xar cpio cctools insert_dylib ];
    unpackPhase =
      ''
        xar -xf $src
        zcat gurobi*mac64tar.pkg/Payload | cpio -i
        tar xf gurobi*_mac64.tar.gz
        sourceRoot=$(echo gurobi*/*64)
        runHook postUnpack
      '';
    patches = [ ./no-clever-setup.patch ];
    postInstall = "mv lib/lib*.so $out/lib";
    postFixup =
      ''
        install_name_tool -change \
          /System/Library/Frameworks/Python.framework/Versions/2.7/Python \
          ${python}/lib/libpython2.7.dylib \
          $out/lib/python2.7/site-packages/gurobipy/gurobipy.so
        install_name_tool -change /Library/gurobi752/mac64/lib/libgurobi75.so \
          $out/lib/libgurobi75.so \
          $out/lib/python2.7/site-packages/gurobipy/gurobipy.so
        insert_dylib --inplace $out/lib/libaes75.so \
          $out/lib/python2.7/site-packages/gurobipy/gurobipy.so
      '';
  }
