{ stdenv, fetchurl, cmake, mesa, libX11, xproto, libXt
, qtLib ? null, tcl ? null, tk ? null, python ? null
, wrapPython ? false }:

# If we are wrapping Python, we need these packages.
assert wrapPython -> tcl != null;
assert wrapPython -> tk != null;
assert wrapPython -> python != null;

with stdenv.lib;

let
  os = stdenv.lib.optionalString;
  majorVersion = "5.10";
  minorVersion = "1";
  version = "${majorVersion}.${minorVersion}";
in

stdenv.mkDerivation rec {
  name = "vtk-${os (qtLib != null) "qvtk-"}${version}";
  src = fetchurl {
    url = "${meta.homepage}files/release/${majorVersion}/vtk-${version}.tar.gz";
    sha256 = "1fxxgsa7967gdphkl07lbfr6dcbq9a72z5kynlklxn7hyp0l18pi";
  };

  buildInputs = [ cmake mesa libX11 xproto libXt ]
    ++ optional (qtLib != null) [ qtLib ]
    ++ optional (wrapPython == true) [ tcl tk python ];

  cmakeFlags = [ "-DBUILD_SHARED_LIBS=ON" ]
    ++ optional (qtLib != null) [ "-DVTK_USE_QT:BOOL=ON" ]
    ++ optional (wrapPython == true) [ "-DVTK_WRAP_PYTHON=ON" ];

  # When building, VTK executables are called at various times.
  preBuild = ''
    export PATH=$PATH:$TMP/VTK${version}/build/bin
    export LIBRARY_PATH=$LIBRARY_PATH:$TMP/VTK${version}/build/bin
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$TMP/VTK${version}/build/bin
  '';
  
  enableParallelBuilding = true;

  setupHook = ./setup-hook.sh;

  shellHook = "source $out/nix-support/setup-hook";

  meta = {
    description = "Open source libraries for 3D computer graphics, image processing and visualization";
    homepage = http://www.vtk.org/;
    license = stdenv.lib.licenses.bsd3;
    maintainers = with stdenv.lib.maintainers; [ viric bbenoist ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
