{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  prometheus-cpp,
  python3,
  caf,
  openssl,
}:
let
  src-cmake = fetchFromGitHub {
    owner = "zeek";
    repo = "cmake";
    rev = "fd0696f9077933660f7da5f81978e86b3e967647";
    hash = "sha256-21wZVwoOB05l/WX/VrVbSx+lFKFQ9MHWjQQD4weavFs=";
  };
  src-3rdparty = fetchFromGitHub {
    owner = "zeek";
    repo = "zeek-3rdparty";
    rev = "a6cc3c7603bb535cf3bec7442140e7126e0577a8";
    hash = "sha256-yzhuTam9zOQ3MP7fk+ACN5P5tHtHXWbyQP73DwISIv8=";
  };
  caf' = caf.overrideAttrs (old: {
    version = "unstable-2024-09-14-zeek";
    src = fetchFromGitHub {
      owner = "zeek";
      repo = "actor-framework";
      rev = "10afbbc5ee40263b258b7cf3f0e5abb436f79e89";
      hash = "sha256-R22eKAFNP2VVA4eL6ycN6aHM0NgDHVll9aFNmOQ/pDc=";
    };
    cmakeFlags = old.cmakeFlags ++ [
      "-DCAF_ENABLE_TESTING=OFF"
    ];
    doCheck = false;
  });
in
stdenv.mkDerivation {
  pname = "zeek-broker";
  version = "2.6.0-unstable-2025-04-23";
  outputs = [
    "out"
    "py"
  ];

  strictDeps = true;

  src = fetchFromGitHub {
    owner = "zeek";
    repo = "broker";
    rev = "5b6cbb8c2d9124aa1fb0bea5799433138dc64cf9";
    hash = "sha256-L6Z+ltX3tJEwZ05zEftrJlOhwbhs06MY9cEJDM2kcck=";
  };
  postUnpack = ''
    rmdir $sourceRoot/cmake $sourceRoot/3rdparty
    ln -s ${src-cmake} ''${sourceRoot}/cmake
    ln -s ${src-3rdparty} ''${sourceRoot}/3rdparty

    # Refuses to build the bindings unless this file is present, but never
    # actually uses it.
    touch $sourceRoot/bindings/python/3rdparty/pybind11/CMakeLists.txt
  '';

  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace bindings/python/CMakeLists.txt --replace " -u -r" ""
  '';

  nativeBuildInputs = [
    cmake
    python3
  ];
  buildInputs = [
    openssl
    prometheus-cpp
    python3.pkgs.pybind11
  ];
  propagatedBuildInputs = [ caf' ];

  cmakeFlags = [
    "-DCAF_ROOT=${caf'}"
    "-DENABLE_STATIC_ONLY:BOOL=${if stdenv.hostPlatform.isStatic then "ON" else "OFF"}"
    "-DPY_MOD_INSTALL_DIR=${placeholder "py"}/${python3.sitePackages}/"
    "-Dprometheus-cpp_ROOT=${lib.getDev prometheus-cpp}"
  ];

  meta = with lib; {
    description = "Zeek's Messaging Library";
    mainProgram = "broker-benchmark";
    homepage = "https://github.com/zeek/broker";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ tobim ];
  };
}
