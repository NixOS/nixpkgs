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

  # This is a massive hack. For now, Trellis doesn't really support
  # installation through an already-built package; you have to build it once to
  # get the tools, then reuse the build directory to build nextpnr -- the
  # 'install' phase doesn't install everything it needs.  This will be fixed in
  # the future but for now we can do this horrific thing.
  trellisRoot = trellis.overrideAttrs (_: {
    installPhase = ''
      mkdir -p $out
      cp *.so ..
      cd ../../.. && cp -R trellis database $out/
    '';
  });
in
stdenv.mkDerivation rec {
  pname = "nextpnr";
  version = "2019.08.10";

  src = fetchFromGitHub {
    owner  = "yosyshq";
    repo   = "nextpnr";
    rev    = "3f26cf50767143e48d29ae691b2a0052c359eb15";
    sha256 = "1gv84svw56ass9idbzh17h3yxkk9ydr40ijf9w72gf72rbixszdr";
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
      "-DTRELLIS_ROOT=${trellisRoot}/trellis"
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
    platforms   = platforms.linux;
    maintainers = with maintainers; [ thoughtpolice ];

    broken = enableGui;
  };
}
