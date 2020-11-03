{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, setuptools_scm
, six
, pytest
}:

buildPythonPackage rec {
  version = "0.2.3";
  pname = "pyvcd";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c0fd7321143e821033f59dd41fc6b0350d1533ddccd4c8fc1d1f76e21cd667de";
  };

  buildInputs = [ setuptools_scm ];
  requiredPythonModules = [ six ];

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
