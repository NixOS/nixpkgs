{ stdenv
, lib
, buildPythonPackage
, isPyPy
, fetchPypi
, pytest
, setuptools_scm
, apipkg
}:

buildPythonPackage rec {
  pname = "execnet";
  version = "1.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "752a3786f17416d491f833a29217dda3ea4a471fc5269c492eebcee8cc4772d3";
  };

  checkInputs = [ pytest ];
  nativeBuildInputs = [ setuptools_scm ];
  propagatedBuildInputs = [ apipkg ];

  # remove vbox tests
  postPatch = ''
    rm -v testing/test_termination.py
    rm -v testing/test_channel.py
    rm -v testing/test_xspec.py
    rm -v testing/test_gateway.py
    ${lib.optionalString isPyPy "rm -v testing/test_multi.py"}
  '';

  checkPhase = ''
    py.test testing
  '';

  __darwinAllowLocalNetworking = true;

  meta = with stdenv.lib; {
    description = "Rapid multi-Python deployment";
    license = licenses.gpl2;
    homepage = "https://execnet.readthedocs.io/";
    maintainers = with maintainers; [ nand0p ];
  };

}
