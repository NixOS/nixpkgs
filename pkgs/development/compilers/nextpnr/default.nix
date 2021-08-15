{ lib, stdenv, fetchFromGitHub, cmake
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
stdenv.mkDerivation rec {
  pname = "nextpnr";
  version = "2021.08.06";

  srcs = [
    (fetchFromGitHub {
      owner  = "YosysHQ";
      repo   = "nextpnr";
      rev    = "dd6376433154e008045695f5420469670b0c3a88";
      sha256 = "197k0a3cjnwinr4nnx7gqvpfi0wdhnmsmvcx12166jg7m1va5kw7";
      name   = "nextpnr";
    })
    (fetchFromGitHub {
      owner  = "YosysHQ";
      repo   = "nextpnr-tests";
      rev    = "ccc61e5ec7cc04410462ec3196ad467354787afb";
      sha256 = "09a0bhrphr3rsppryrfak4rhziyj8k3s17kgb0vgm0abjiz0jgam";
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
