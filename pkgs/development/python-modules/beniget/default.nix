{ lib
, buildPythonPackage
, fetchPypi
, gast
}:

buildPythonPackage rec {
  pname = "beniget";
  version = "0.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "062c893be9cdf87c3144fb15041cce4d81c67107c1591952cd45fdce789a0ff1";
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
