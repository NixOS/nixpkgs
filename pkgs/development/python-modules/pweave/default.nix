{ stdenv
, buildPythonPackage
, fetchPypi
, mock
, matplotlib
, pkgs
}:

buildPythonPackage rec {
  pname = "Pweave";
  version = "0.25";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1isqjz66c7vxdaqfwpkspki9p4054dsfx7pznwz28ik634hnj3qw";
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
