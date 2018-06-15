{ fetchurl, python }:
assert python.pkgs.isPy27;
let utf =
  if python.ucsEncoding == 2 then "16"
  else if python.ucsEncoding == 4 then "32"
  else throw "Unsupported python UCS encoding UCS${toString python.ucsEncoding}";
in python.pkgs.buildPythonPackage
  { name = "gurobipy-7.5.2";
    src = fetchurl
      { url = "http://packages.gurobi.com/7.5/gurobi7.5.2_linux64.tar.gz";
        sha256 = "13i1dl22lnmg7z9mb48zl3hy1qnpwdpr0zl2aizda0qnb7my5rnj";
      };
    setSourceRoot = "sourceRoot=$(echo gurobi*/*64)";
    patches = [ ./no-clever-setup.patch ];
    postInstall = "mv lib/libaes*.so* lib/libgurobi*.so* $out/lib";
    postFixup =
      ''
        patchelf --set-rpath $out/lib \
          $out/lib/python2.7/site-packages/gurobipy/gurobipy.so
        patchelf --add-needed libaes75.so \
          $out/lib/python2.7/site-packages/gurobipy/gurobipy.so
      '';
  }
