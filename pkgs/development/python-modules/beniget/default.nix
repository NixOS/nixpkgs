{ lib
, buildPythonPackage
, fetchPypi
, gast
}:

buildPythonPackage rec {
  pname = "beniget";
  version = "0.4.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "75554b3b8ad0553ce2f607627dad3d95c60c441189875b98e097528f8e23ac0c";
  };

  propagatedBuildInputs = [
    gast
  ];

  meta = {
    description = "Extract semantic information about static Python code";
    homepage = "https://github.com/serge-sans-paille/beniget";
    license = lib.licenses.bsd3;
  };
}
