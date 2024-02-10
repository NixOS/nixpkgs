{ lib
, buildPythonPackage
, fetchPypi
, cargo
, rustPlatform
, rustc
, numpy
}:

buildPythonPackage rec {
  pname = "quil";
  version = "0.6.6";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-esmYYSKxomOUAAgXOkPs16XnlfELD7l9ftu04Wi4wHk=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-N2022n6i/E/0e+rJ6V1J3eavDYtOaESErXIlOizTnJI=";
  };

  nativeBuildInputs = [
    cargo
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    rustc
  ];

  propagatedBuildInputs = [
    numpy
  ];

  pythonImportsCheck = [ "quil" ];

  meta = with lib; {
    description = "A Python package for building and parsing Quil programs";
    homepage = "https://pypi.org/project/quil/";
    license = licenses.asl20;
    maintainers = with maintainers; [ ocfox ];
  };
}
