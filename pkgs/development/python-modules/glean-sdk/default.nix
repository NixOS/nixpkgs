{
  stdenv,
  lib,
  buildPythonPackage,
  cargo,
  cffi,
  fetchPypi,
  glean-parser,
  iso8601,
  lmdb,
  pkg-config,
  pytest-localserver,
  pytestCheckHook,
  python,
  pythonOlder,
  rustc,
  rustPlatform,
  semver,
  setuptools-rust,
}:

buildPythonPackage rec {
  pname = "glean-sdk";
  version = "52.7.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-sLjdGHiS7Co/oA9gQyAFkD14tAYjmwjWcPr4CRrzw/0=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-5TlgWcLmjklxhtDbB0aRF71iIRTJwetFj1Jii1DGdvU=";
  };

  nativeBuildInputs = [
    cargo
    pkg-config
    rustc
    rustPlatform.cargoSetupHook
    setuptools-rust
  ];

  buildInputs = [ lmdb ];

  propagatedBuildInputs = [
    cffi
    glean-parser
    iso8601
    semver
  ];

  nativeCheckInputs = [
    pytest-localserver
    pytestCheckHook
  ];

  disabledTests = [
    # RuntimeError: No ping received.
    "test_client_activity_api"
    "test_flipping_upload_enabled_respects_order_of_events"
  ];

  postInstallCheck = lib.optionalString stdenv.hostPlatform.isElf ''
    readelf -a $out/${python.sitePackages}/glean/libglean_ffi.so | grep -F 'Shared library: [liblmdb.so'
  '';

  pythonImportsCheck = [ "glean" ];

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Telemetry client libraries and are a part of the Glean project";
    homepage = "https://mozilla.github.io/glean/book/index.html";
    license = licenses.mpl20;
    maintainers = with maintainers; [ melling ];
  };
}
