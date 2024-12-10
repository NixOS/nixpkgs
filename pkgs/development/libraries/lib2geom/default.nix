{
  stdenv,
  fetchpatch,
  fetchFromGitLab,
  cmake,
  ninja,
  pkg-config,
  boost,
  glib,
  gsl,
  cairo,
  double-conversion,
  gtest,
  lib,
}:

stdenv.mkDerivation rec {
  pname = "lib2geom";
  version = "1.3";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitLab {
    owner = "inkscape";
    repo = "lib2geom";
    rev = "refs/tags/${version}";
    hash = "sha256-llUpW8VRBD8RKaGfyedzsMbLRb8DIo0ePt6m2T2w7Po=";
  };

  patches = [
    # Fix compilation with Clang.
    # https://gitlab.com/inkscape/lib2geom/-/merge_requests/102
    (fetchpatch {
      url = "https://gitlab.com/inkscape/lib2geom/-/commit/a5b5ac7d992023f8a80535ede60421e73ecd8e20.patch";
      hash = "sha256-WJYkk3WRYVyPSvyTbKDUrYvUwFgKA9mmTiEWtYQqM4Q=";
    })
    (fetchpatch {
      url = "https://gitlab.com/inkscape/lib2geom/-/commit/23d9393af4bee17aeb66a3c13bdad5dbed982d08.patch";
      hash = "sha256-LAaGMIXpDI/Wzv5E2LasW1Y2/G4ukhuEzDmFu3AzZOA=";
    })

    # Fix ellipses rendering near page corners.
    # https://gitlab.com/inkscape/lib2geom/-/issues/66
    (fetchpatch {
      url = "https://gitlab.com/inkscape/lib2geom/-/commit/039ce8d4af23a0a2a9d48eb970b321d9795dcc08.patch";
      hash = "sha256-JfgGrqBcYSYKcdl4Bt7vGZ4aTBPSHM6JjZ95IlzxPwI=";
    })
    (fetchpatch {
      url = "https://gitlab.com/inkscape/lib2geom/-/commit/cf523857e48c87f9f6a09217bdf935fff457823d.patch";
      hash = "sha256-BRg8ANHMSgoi6vt9PNbhwG1fRkzEPXb4gPTPO3sY0XE=";
    })
  ];

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
  ];

  buildInputs = [
    boost
    glib
    gsl
    cairo
    double-conversion
  ];

  nativeCheckInputs = [
    gtest
  ];

  cmakeFlags = [
    "-D2GEOM_BUILD_SHARED=ON"
  ];

  doCheck = true;

  # TODO: Update cmake hook to make it simpler to selectively disable cmake tests: #113829
  checkPhase =
    let
      disabledTests =
        lib.optionals stdenv.isAarch64 [
          # Broken on all platforms, test just accidentally passes on some.
          # https://gitlab.com/inkscape/lib2geom/-/issues/63
          "elliptical-arc-test"
        ]
        ++ lib.optionals stdenv.hostPlatform.isMusl [
          # Fails due to rounding differences
          # https://gitlab.com/inkscape/lib2geom/-/issues/70
          "circle-test"
        ];
    in
    ''
      runHook preCheck
      ctest --output-on-failure -E '^${lib.concatStringsSep "|" disabledTests}$'
      runHook postCheck
    '';

  meta = with lib; {
    description = "Easy to use 2D geometry library in C++";
    homepage = "https://gitlab.com/inkscape/lib2geom";
    license = [
      licenses.lgpl21Only
      licenses.mpl11
    ];
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.unix;
  };
}
