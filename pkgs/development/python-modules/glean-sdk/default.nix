{ lib
, buildPythonPackage
, fetchPypi
, rustPlatform
, rustc
, cargo
, setuptools-rust
# build inputs
, cffi
, glean-parser
}:

buildPythonPackage rec {
  pname = "glean-sdk";
  version = "44.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-gzLsBwq3wrFde5cEb5+oFLW4KrwoiZpr22JbJhNr1yk=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    sha256 = "sha256-lWFv8eiA3QHp5bhcg4qon/dvKUbFbtH1Q2oXGkk0Me0=";
  };

  nativeBuildInputs = [
    rustc
    cargo
    setuptools-rust
    rustPlatform.cargoSetupHook
  ];
  propagatedBuildInputs = [
    cffi
    glean-parser
  ];

  pythonImportsCheck = [ "glean" ];

  meta = with lib; {
    description = "Modern cross-platform telemetry client libraries and are a part of the Glean project";
    homepage = "https://mozilla.github.io/glean/book/index.html";
    license = licenses.mpl20;
    maintainers = [ maintainers.kvark ];
  };
}
