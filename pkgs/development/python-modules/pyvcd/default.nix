{ lib
, buildPythonPackage
, fetchPypi
, setuptools_scm
, six
, pytest }:

buildPythonPackage rec {
  version = "0.1.6";
  pname = "pyvcd";

  src = fetchPypi {
    inherit pname version;
    sha256 = "285fcd96c3ee482e7b222bdd01d5dd19c2f5a0ad9b8e950baa98d386a2758c8f";
  };

  buildInputs = [ setuptools_scm ];
  propagatedBuildInputs = [ six ];

  checkPhase = ''
    py.test
  '';

  checkInputs = [ pytest ];

  meta = with lib; {
    description = "Python package for writing Value Change Dump (VCD) files";
    homepage = https://github.com/SanDisk-Open-Source/pyvcd;
    license = licenses.mit;
    maintainers = [ maintainers.sb0 ];
  };
}
