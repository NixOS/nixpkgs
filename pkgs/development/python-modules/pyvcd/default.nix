{ lib
, buildPythonPackage
, fetchPypi
, setuptools_scm
, six
, pytest
}:

buildPythonPackage rec {
  version = "0.1.7";
  pname = "pyvcd";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1ixpdl0qiads81h8s9h9r9z0cyc9dlmvi01nfjggxixvbb17305y";
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
    changelog = "https://github.com/SanDisk-Open-Source/pyvcd/blob/${version}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = [ maintainers.sb0 maintainers.emily ];
  };
}
