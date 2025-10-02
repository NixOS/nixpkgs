{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  rustPlatform,
  cargo,
  pkg-config,
  rustc,
  rustfmt,
  setuptools-rust,
  openssl,
  msgpack,
  fetchpatch,
  nixosTests,
}:

buildPythonPackage rec {
  pname = "etebase";
  version = "0.31.7";

  src = fetchFromGitHub {
    owner = "etesync";
    repo = "etebase-py";
    rev = "v${version}";
    hash = "sha256-ZNUUp/0fGJxL/Rt8sAZ864rg8uCcNybIYSk4POt0vqg=";
  };

  # https://github.com/etesync/etebase-py/pull/54
  patches = [
    # fix python 3.12 build
    (fetchpatch {
      url = "https://github.com/etesync/etebase-py/commit/898eb3aca1d4eb30d4aeae15e35d0bc45dd7b3c8.patch";
      hash = "sha256-0BDUTztiC4MiwwNEDFtfc5ruc69Qk+svepQZRixNJgA=";
    })
    # replace flapigen git dependency in Cargo.lock
    (fetchpatch {
      url = "https://github.com/etesync/etebase-py/commit/7e9e4244a144dd46383d8be950d3df79e28eb069.patch";
      hash = "sha256-8EH8Sc3UnmuCrSwDf3+as218HiG2Ed3r+FCMrUi5YrI=";
    })
  ];

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-tFOZJFrNge3N+ux2Hp4Mlm9K/AXYxuuBzEQdQYGGDjg=";
    inherit patches;
  };

  format = "pyproject";

  nativeBuildInputs = [
    pkg-config
    rustfmt
    setuptools-rust
    rustPlatform.cargoSetupHook
    cargo
    rustc
  ];

  buildInputs = [ openssl ];

  propagatedBuildInputs = [ msgpack ];

  postPatch = ''
    # Use system OpenSSL, which gets security updates.
    substituteInPlace Cargo.toml \
      --replace ', features = ["vendored"]' ""
  '';

  pythonImportsCheck = [ "etebase" ];

  passthru.tests = {
    inherit (nixosTests) etebase-server;
  };

  meta = with lib; {
    homepage = "https://www.etebase.com/";
    description = "Python client library for Etebase";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
