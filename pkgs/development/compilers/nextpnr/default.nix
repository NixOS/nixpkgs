{ stdenv, fetchFromGitHub, cmake
, boost, python3, eigen
, icestorm, trellis

# TODO(thoughtpolice) Currently the GUI build seems broken at runtime on my
# laptop (and over a remote X server on my server...), so mark it broken for
# now, with intent to fix later.
, enableGui ? false
, qtbase, wrapQtAppsHook
}:

let
  boostPython = boost.override { python = python3; enablePython = true; };
in
stdenv.mkDerivation rec {
  pname = "nextpnr";
  version = "2019.08.21";

  src = fetchFromGitHub {
    owner  = "yosyshq";
    repo   = "nextpnr";
    rev    = "c192ba261d77ad7f0a744fb90b01e4a5b63938c4";
    sha256 = "0g2ar1z89b31qw5vgqj2rrcv9rzncs94184dgcsrz19p866654mf";
  };

  nativeBuildInputs
     = [ cmake ]
    ++ (stdenv.lib.optional enableGui wrapQtAppsHook);
  buildInputs
     = [ boostPython python3 eigen ]
    ++ (stdenv.lib.optional enableGui qtbase);

  enableParallelBuilding = true;
  cmakeFlags =
    [ "-DARCH=generic;ice40;ecp5"
      "-DICEBOX_ROOT=${icestorm}/share/icebox"
      "-DTRELLIS_ROOT=${trellis}/share/trellis"
      "-DPYTRELLIS_LIBDIR=${trellis}/lib/trellis"
      "-DUSE_OPENMP=ON"
      # warning: high RAM usage
      "-DSERIALIZE_CHIPDB=OFF"
      # use PyPy for icestorm if enabled
      "-DPYTHON_EXECUTABLE=${icestorm.pythonInterp}"
    ] ++ (stdenv.lib.optional (!enableGui) "-DBUILD_GUI=OFF");

  # Fix the version number. This is a bit stupid (and fragile) in practice
  # but works ok. We should probably make this overrideable upstream.
  patchPhase = with builtins; ''
    substituteInPlace ./CMakeLists.txt \
      --replace 'git log -1 --format=%h' 'echo ${substring 0 11 src.rev}'
  '';

  meta = with stdenv.lib; {
    description = "Place and route tool for FPGAs";
    homepage    = https://github.com/yosyshq/nextpnr;
    license     = licenses.isc;
    platforms   = platforms.all;
    maintainers = with maintainers; [ thoughtpolice emily ];

    broken = enableGui;
  };
}
