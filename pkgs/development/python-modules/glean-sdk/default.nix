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
  version = "52.6.0";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-TTV6oydUP2znEOm7KZElugNDfROnlPmyC19Ig1H8/wM=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-Np2TfgKP3yfJqA4WZyyedGp9XtKJjDikUov5pvB/opk=";
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

  pythonImportsCheck = [
    "glean"
  ];

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Telemetry client libraries and are a part of the Glean project";
    homepage = "https://mozilla.github.io/glean/book/index.html";
    license = licenses.mpl20;
    maintainers = with maintainers; [ melling ];
  };
}
