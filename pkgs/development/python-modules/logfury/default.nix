{ lib
, buildPythonPackage
, fetchPypi
, funcsigs
, six
}:

buildPythonPackage rec {
  pname = "logfury";
  version = "0.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1lywirv3d1lw691mc4mfpz7ak6r49klri43bbfgdnvsfppxminj2";
  };

  propagatedBuildInputs = [
    funcsigs
    six
  ];

  # No tests
  doCheck = false;

  meta = {
    description = "Logfury is for python library maintainers. It allows for responsible, low-boilerplate logging of method calls.";
    homepage = https://github.com/ppolewicz/logfury;
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ jwiegley ];
  };
}