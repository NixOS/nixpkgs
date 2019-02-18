{ stdenv
, buildPythonPackage
, fetchPypi
, pytest
, setuptools_scm
, apipkg
}:

buildPythonPackage rec {
  pname = "execnet";
  version = "1.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a7a84d5fa07a089186a329528f127c9d73b9de57f1a1131b82bb5320ee651f6a";
  };

  checkInputs = [ pytest  ];
  nativeBuildInputs = [ setuptools_scm ];
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
