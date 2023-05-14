{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, setuptools-scm
, six
, pytestCheckHook
}:

buildPythonPackage rec {
  version = "0.3.0";
  pname = "pyvcd";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ec4d9198bd20f9e07d78f6558ff8bcd45b172ee332e7e8a4588727eeb6a362bc";
  };

  buildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [ six ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Python package for writing Value Change Dump (VCD) files";
    homepage = "https://github.com/SanDisk-Open-Source/pyvcd";
    changelog = "https://github.com/SanDisk-Open-Source/pyvcd/blob/${version}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ sb0 emily ];
  };
}
