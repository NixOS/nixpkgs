{ lib
, fetchPypi
, buildPythonPackage
, setuptools_scm
, cffi
}:

buildPythonPackage rec {
  pname = "mip";
  version = "1.13.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ynczcabpxqwg797wscw1gck4wg574wc2zyp77qsas8jv7xb6b5j";
  };

  buildInputs = [ setuptools_scm cffi ];
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/coin-or/python-mip";
    description = "MIP is a collection of tools for Mixed-Integer Linear programs.";
    maintainers = with maintainers; [ danielbarter ];
    license = licenses.mit;
  };
}
