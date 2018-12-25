{ stdenv
, buildPythonPackage
, fetchPypi
, mock
, matplotlib
, pkgs
}:

buildPythonPackage rec {
  pname = "Pweave";
  version = "0.30.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5e5298d90e06414a01f48e0d6aa4c36a70c5f223d929f2a9c7e2d388451c7357";
  };

  buildInputs = [ mock pkgs.glibcLocales ];
  propagatedBuildInputs = [ matplotlib ];

  # fails due to trying to run CSS as test
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Scientific reports with embedded python computations with reST, LaTeX or markdown";
    homepage = http://mpastell.com/pweave/ ;
    license = licenses.bsd3;
  };

}
