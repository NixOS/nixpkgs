{ stdenv
, buildPythonPackage
, fetchPypi
, pytest
, setuptools_scm
, apipkg
}:

buildPythonPackage rec {
  pname = "execnet";
  version = "1.4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1rpk1vyclhg911p3hql0m0nrpq7q7mysxnaaw6vs29cpa6kx8vgn";
  };

  buildInputs = [ pytest setuptools_scm ];
  propagatedBuildInputs = [ apipkg ];

  # remove vbox tests
  postPatch = ''
    rm -v testing/test_termination.py
    rm -v testing/test_channel.py
    rm -v testing/test_xspec.py
    rm -v testing/test_gateway.py
  '';

  checkPhase = ''
    py.test testing
  '';

  __darwinAllowLocalNetworking = true;

  meta = with stdenv.lib; {
    description = "Rapid multi-Python deployment";
    license = licenses.gpl2;
    homepage = "http://codespeak.net/execnet";
    maintainers = with maintainers; [ nand0p ];
  };

}
