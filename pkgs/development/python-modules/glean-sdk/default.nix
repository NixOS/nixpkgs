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
, setuptools-rust
}:

buildPythonPackage rec {
  pname = "glean-sdk";
  version = "50.1.2";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-avTIinFBSoCHeCiX7EoS4ucBK6FyFC1SuAFpSdxwPUk=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256:10k8684665iawf1yswx39s4cj6c5d37j4d7jgbn0fcm08qlkfzxi";
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
  ];

  checkInputs = [
    pytest-localserver
    pytestCheckHook
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
