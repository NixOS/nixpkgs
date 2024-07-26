{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, setuptools-scm
, six
, pytestCheckHook
}:

buildPythonPackage rec {
  version = "0.4.0";
  format = "setuptools";
  pname = "pyvcd";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Mb4/UBRBqbjF3HJmD/e5z++bQ7ISGiPZb1htKGMnApA=";
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
