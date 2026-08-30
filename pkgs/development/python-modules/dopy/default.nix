{
  lib,
  pkgs,
  buildPythonPackage,
  requests,
  six,
}:

buildPythonPackage {
  pname = "dopy";
  version = "2016-01-04";
  format = "setuptools";

  src = pkgs.fetchFromGitHub {
    owner = "Wiredcraft";
    repo = "dopy";
    rev = "cb443214166a4e91b17c925f40009ac883336dc3";
    hash = "sha256-pmCCdbmiV0oWRfYJWNLCRi/PzV/SpKmUSco+hhMSuio=";
  };

  propagatedBuildInputs = [
    requests
    six
  ];

  # contains no tests
  doCheck = false;
  pythonImportsCheck = [ "dopy" ];

  meta = {
    description = "Digital Ocean API python wrapper";
    homepage = "https://github.com/Wiredcraft/dopy";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lihop ];
  };
}
