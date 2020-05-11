{ lib
, fetchPypi
, buildPythonPackage
, numpy
}:

buildPythonPackage rec {
  pname = "pyache";
  version = "0.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1m6ipm1684rllaak0q23jn0436mjwxxzcyfypirxrj702ivi7dgn";
  };

  propagatedBuildInputs = [
    numpy
  ];

  meta = with lib; {
    description = "Python numpy caching library";
    homepage = "https://github.com/MycroftAI/pyache";
    maintainers = with maintainers; [ timokau ];
    license = licenses.asl20;
  };
}
