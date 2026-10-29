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
    rev = "913c8a1a9cdece3461a39a07c330b89baa09be99";
    hash = "sha256-AUPL6Q8tiS2gsgTBr7zT/xUprtboCHgPKs0vSJwuuAY=";
  };
  src-3rdparty = fetchFromGitHub {
    owner = "zeek";
    repo = "zeek-3rdparty";
    rev = "a6cc3c7603bb535cf3bec7442140e7126e0577a8";
    hash = "sha256-yzhuTam9zOQ3MP7fk+ACN5P5tHtHXWbyQP73DwISIv8=";
  };
  prometheus-cpp' = prometheus-cpp.overrideAttrs (old: {
    # Zeek expects Broker to include prometheus-cpp symbols rather than link them dynamically.
    cmakeFlags = builtins.filter (flag: flag != "-DBUILD_SHARED_LIBS=ON") old.cmakeFlags ++ [
      "-DBUILD_SHARED_LIBS=OFF"
    ];
  });
  caf' = caf.overrideAttrs (old: {
    version = "unstable-2025-07-23-zeek";
    src = fetchFromGitHub {
      owner = "zeek";
      repo = "actor-framework";
      rev = "4aa660d003d8bbb922a33fb7a31f80d9d3271262";
      hash = "sha256-OlrW+gk/oLEEIWRSugI1DqRJ+KYF4ZJxHVWKXWllGjU=";
    };
    cmakeFlags = old.cmakeFlags ++ [
      "-DCAF_ENABLE_TESTING=OFF"
    ];
    doCheck = false;
  });
in
stdenv.mkDerivation {
  pname = "zeek-broker";
  version = "2.8.0-unstable-2026-08-07";
  outputs = [
    "out"
    "py"
  ];

  strictDeps = true;

  src = fetchFromGitHub {
    owner = "zeek";
    repo = "broker";
    rev = "d07d9f67f5b8795b5402ca4b6eb433bfb15dcedb";
    hash = "sha256-P+i7Oq5Iv68vNsusPtxlrf09B4NVoRiJ/m9biCq5Ops=";
  };
  postUnpack = ''
    rmdir $sourceRoot/cmake $sourceRoot/caf $sourceRoot/3rdparty
    ln -s ${src-cmake} ''${sourceRoot}/cmake
    ln -s ${caf'.src} ''${sourceRoot}/caf
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
    prometheus-cpp'
    python3.pkgs.pybind11
  ];
  propagatedBuildInputs = [ caf' ];

  cmakeFlags = [
    "-DCAF_ROOT=${caf'}"
    "-DENABLE_STATIC_ONLY:BOOL=${if stdenv.hostPlatform.isStatic then "ON" else "OFF"}"
    "-DPY_MOD_INSTALL_DIR=${placeholder "py"}/${python3.sitePackages}/"
    "-Dprometheus-cpp_ROOT=${lib.getDev prometheus-cpp'}"
  ];

  meta = {
    description = "Zeek's Messaging Library";
    homepage = "https://github.com/zeek/broker";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ tobim ];
  };
}
