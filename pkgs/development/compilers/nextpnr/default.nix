{ stdenv, fetchFromGitHub, cmake
, boost, python3, eigen
, icestorm, trellis
, llvmPackages

, enableGui ? true
, wrapQtAppsHook
, qtbase
, OpenGL ? null
}:

let
  boostPython = boost.override { python = python3; enablePython = true; };
in
with stdenv; mkDerivation rec {
  pname = "nextpnr";
  version = "2019.09.28";

  src = fetchFromGitHub {
    owner  = "yosyshq";
    repo   = "nextpnr";
    rev    = "7cd1e0495122847611b17a8d1f007d97a05b288c";
    sha256 = "13y739l92plb22g73jf35pyh3y94b2vq0i65r9c31r2rb7fw4bbl";
    fetchSubmodules = true;
  };

  nativeBuildInputs
     = [ cmake ]
    ++ (lib.optional enableGui wrapQtAppsHook);
  buildInputs
     = [ boostPython python3 eigen ]
    ++ (lib.optional enableGui qtbase)
    ++ (lib.optional stdenv.cc.isClang llvmPackages.openmp);

  enableParallelBuilding = true;
  cmakeFlags =
    [ "-DARCH=generic;ice40;ecp5"
      "-DBUILD_TESTS=ON"
      "-DICEBOX_ROOT=${icestorm}/share/icebox"
      "-DTRELLIS_ROOT=${trellis}/share/trellis"
      "-DPYTRELLIS_LIBDIR=${trellis}/lib/trellis"
      "-DUSE_OPENMP=ON"
      # warning: high RAM usage
      "-DSERIALIZE_CHIPDB=OFF"
    ]
    ++ (lib.optional (!enableGui) "-DBUILD_GUI=OFF")
    ++ (lib.optional (enableGui && stdenv.isDarwin)
        "-DOPENGL_INCLUDE_DIR=${OpenGL}/Library/Frameworks");

  # Fix the version number. This is a bit stupid (and fragile) in practice
  # but works ok. We should probably make this overrideable upstream.
  patchPhase = with builtins; ''
    substituteInPlace ./CMakeLists.txt \
      --replace 'git log -1 --format=%h' 'echo ${substring 0 11 src.rev}'

    # use PyPy for icestorm if enabled
    substituteInPlace ./ice40/family.cmake \
      --replace ''\'''${PYTHON_EXECUTABLE}' '${icestorm.pythonInterp}'
  '';

  doCheck = true;

  postFixup = lib.optionalString enableGui ''
    wrapQtApp $out/bin/nextpnr-generic
    wrapQtApp $out/bin/nextpnr-ice40
    wrapQtApp $out/bin/nextpnr-ecp5
  '';

  meta = with lib; {
    description = "Place and route tool for FPGAs";
    homepage    = https://github.com/yosyshq/nextpnr;
    license     = licenses.isc;
    platforms   = platforms.all;
    maintainers = with maintainers; [ thoughtpolice emily ];
  };
}
