{ stdenv, fetchurl, python }:
assert python.pkgs.isPy27;
let utf =
  if python.ucsEncoding == 2 then "16"
  else if python.ucsEncoding == 4 then "32"
  else throw "Unsupported python UCS encoding UCS${toString python.ucsEncoding}";
in stdenv.mkDerivation
  { name = "gurobipy-7.0.2";
    src = fetchurl
      { url = "http://packages.gurobi.com/7.0/gurobi7.0.2_linux64.tar.gz";
        sha256 = "1lgdj4cncjvnnw8dppiax7q2j8121pxyg9iryj8v26mrk778dnmn";
      };
    buildCommand =
      ''
        # Unpack
        tar xf $src

        # Install
        cd gurobi*/linux64
        mkdir -p $out/lib/python2.7/site-packages
        mv lib/python2.7_utf${utf}/gurobipy \
          $out/lib/python2.7/site-packages
        mv lib/python2.7_utf${utf}/gurobipy.so \
          $out/lib/python2.7/site-packages/gurobipy
        mv lib/libaes*.so* lib/libgurobi*.so* $out/lib

        # Fixup
        patchelf --set-rpath $out/lib \
          $out/lib/python2.7/site-packages/gurobipy/gurobipy.so
        patchelf --add-needed libaes70.so \
          $out/lib/python2.7/site-packages/gurobipy/gurobipy.so
      '';
  }
