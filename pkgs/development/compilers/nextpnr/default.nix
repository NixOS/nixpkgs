{ stdenv, fetchFromGitHub, cmake
, boost, python3, eigen
, icestorm, trellis
, llvmPackages

, enableGui ? false
, wrapQtAppsHook ? null
, qtbase ? null
, OpenGL ? null
}:

let
  boostPython = boost.override { python = python3; enablePython = true; };
in
with stdenv; mkDerivation rec {
  pname = "nextpnr";
  version = "2021.01.02";

  srcs = [
    (fetchFromGitHub {
      owner  = "YosysHQ";
      repo   = "nextpnr";
      rev    = "9b9628047c01a970cfe20f83f2b7129ed109440d";
      sha256 = "0pcv96d0n40h2ipywi909hpzlys5b6r4pamc320qk1xxhppmgkmm";
      name   = "nextpnr";
    })
    (fetchFromGitHub {
      owner  = "YosysHQ";
      repo   = "nextpnr-tests";
      rev    = "8f93e7e0f897b1b5da469919c9a43ba28b623b2a";
      sha256 = "0zpd0w49k9l7rs3wmi2v8z5s4l4lad5rprs5l83w13667himpzyc";
      name   = "nextpnr-tests";
    })
  ];

  sourceRoot = "nextpnr";

  nativeBuildInputs
     = [ cmake ]
    ++ (lib.optional enableGui wrapQtAppsHook);
  buildInputs
     = [ boostPython python3 eigen ]
    ++ (lib.optional enableGui qtbase)
    ++ (lib.optional stdenv.cc.isClang llvmPackages.openmp);

  cmakeFlags =
    [ "-DCURRENT_GIT_VERSION=${lib.substring 0 7 (lib.elemAt srcs 0).rev}"
      "-DARCH=generic;ice40;ecp5"
      "-DBUILD_TESTS=ON"
      "-DICESTORM_INSTALL_PREFIX=${icestorm}"
      "-DTRELLIS_INSTALL_PREFIX=${trellis}"
      "-DTRELLIS_LIBDIR=${trellis}/lib/trellis"
      "-DUSE_OPENMP=ON"
      # warning: high RAM usage
      "-DSERIALIZE_CHIPDBS=OFF"
    ]
    ++ (lib.optional enableGui "-DBUILD_GUI=ON")
    ++ (lib.optional (enableGui && stdenv.isDarwin)
        "-DOPENGL_INCLUDE_DIR=${OpenGL}/Library/Frameworks");

  patchPhase = with builtins; ''
    # use PyPy for icestorm if enabled
    substituteInPlace ./ice40/family.cmake \
      --replace ''\'''${PYTHON_EXECUTABLE}' '${icestorm.pythonInterp}'
  '';

  preBuild = ''
    ln -s ../nextpnr-tests tests
  '';

  doCheck = true;

  postFixup = lib.optionalString enableGui ''
    wrapQtApp $out/bin/nextpnr-generic
    wrapQtApp $out/bin/nextpnr-ice40
    wrapQtApp $out/bin/nextpnr-ecp5
  '';

  meta = with lib; {
    description = "Place and route tool for FPGAs";
    homepage    = "https://github.com/yosyshq/nextpnr";
    license     = licenses.isc;
    platforms   = platforms.all;
    maintainers = with maintainers; [ thoughtpolice emily ];
  };
}
