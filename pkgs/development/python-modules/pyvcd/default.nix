{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, setuptools_scm
, six
, pytest
}:

buildPythonPackage rec {
  version = "0.2.4";
  pname = "pyvcd";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "071e51a8362908ad5a2a12f078185639b98b20b653a56f01679de169d0fa425d";
  };

  buildInputs = [ setuptools_scm ];
  propagatedBuildInputs = [ six ];

  checkPhase = ''
    py.test
  '';

  checkInputs = [ pytest ];

  meta = with lib; {
    description = "Python package for writing Value Change Dump (VCD) files";
    homepage = "https://github.com/SanDisk-Open-Source/pyvcd";
    changelog = "https://github.com/SanDisk-Open-Source/pyvcd/blob/${version}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = [ maintainers.sb0 maintainers.emily ];
  };
}
