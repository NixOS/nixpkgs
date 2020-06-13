{ lib
, buildPythonPackage
, fetchPypi
, setuptools_scm
, six
, pytest
}:

buildPythonPackage rec {
  version = "0.2.1";
  pname = "pyvcd";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fad6b9e2cd68049968a43fd9f465a1f924050c0a654e28cc5aa04c1908f283ab";
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
