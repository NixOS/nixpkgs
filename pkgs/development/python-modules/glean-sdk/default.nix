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
    hash = "sha256-gzLsBwq3wrFde5cEb5+oFLW4KrwoiZpr22JbJhNr1yk=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    sha256 = "sha256-avTIinFBSoCHeCiX7EoS4ucBK6FyFC1SuAFpSdxwPUk=";
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
