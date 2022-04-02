{ lib, buildPythonPackage, fetchPypi, jsonconversion, six, pytestCheckHook }:

buildPythonPackage rec {
  pname = "amazon-ion";
  version = "0.8.0";

  src = fetchPypi {
    pname = "amazon.ion";
    inherit version;
    sha256 = "sha256-vtztUHSnGoPYozhwvigxEdieVtbKNfV4B5yZ4MHaWGw=";
  };

  postPatch = ''
    substituteInPlace setup.py --replace "'pytest-runner'," ""
  '';

  propagatedBuildInputs = [ jsonconversion six ];

  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "amazon.ion" ];

  meta = with lib; {
    description = "A Python implementation of Amazon Ion";
    homepage = "https://github.com/amzn/ion-python";
    license = licenses.asl20;
    maintainers = [ maintainers.terlar ];
  };
}
