{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "cronsim";
  version = "2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-nwlSAbD+y0l9jyVSVShzWeC7nC5RZRD/kAhCi3Nd9xY=";
  };

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "cronsim" ];

  meta = with lib; {
    description = "Cron expression parser and evaluator";
    homepage = "https://github.com/cuu508/cronsim";
    license = licenses.bsd3;
    maintainers = with maintainers; [ phaer ];
  };
}
