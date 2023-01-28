{ stdenv
, lib
, buildPythonPackage
, cargo
, cffi
, fetchPypi
, glean-parser
, iso8601
, pytest-localserver
, pytestCheckHook
, pythonOlder
, rustc
, rustPlatform
, semver
, setuptools-rust
}:

buildPythonPackage rec {
  pname = "glean-sdk";
  version = "51.2.0";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-4EXCYthMabdmxWYltcnO0UTNeAYXwXQeRfwxt1WD3Ug=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-qOGoonutuIY+0UVaVSVVt0NbqEICdNs3qHWG0Epmkl0=";
  };

  nativeBuildInputs = [
    cargo
    rustc
    rustPlatform.cargoSetupHook
    setuptools-rust
  ];

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
  ];

  postPatch = ''
    substituteInPlace glean-core/python/setup.py \
      --replace "glean_parser==5.0.1" "glean_parser>=5.0.1"
  '';

  pythonImportsCheck = [
    "glean"
  ];

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Telemetry client libraries and are a part of the Glean project";
    homepage = "https://mozilla.github.io/glean/book/index.html";
    license = licenses.mpl20;
    maintainers = [];
  };
}
