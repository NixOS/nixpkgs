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
    rev = "a1482b8f9829cea870b4db75c085de1249e11bcb";
    hash = "sha256-kFkLig0g/sBKRg8EnfUldj9R7qX6V+c8Ap98p0YBsIw=";
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
  version = "2.8.0-unstable-2026-08-11";
  outputs = [
    "out"
    "py"
  ];

  strictDeps = true;

  src = fetchFromGitHub {
    owner = "zeek";
    repo = "broker";
    rev = "fdca6b8ef4b95ec6518a32db46503c28cc812be4";
    hash = "sha256-GuqmbFCIeS9maW9cy+dIMqwOTTiQIKJX1nVQoAIxDpA=";
  };
  postUnpack = ''
    rmdir $sourceRoot/cmake $sourceRoot/caf
    ln -s ${src-cmake} ''${sourceRoot}/cmake
    ln -s ${caf'.src} ''${sourceRoot}/caf

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
