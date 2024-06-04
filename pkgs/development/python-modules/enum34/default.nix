{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonAtLeast,
  unittestCheckHook,
}:

if pythonAtLeast "3.4" then
  null
else
  buildPythonPackage rec {
    pname = "enum34";
    version = "1.1.10";

    src = fetchPypi {
      inherit pname version;
      sha256 = "cce6a7477ed816bd2542d03d53db9f0db935dd013b70f336a95c73979289f248";
    };

    nativeCheckInputs = [ unittestCheckHook ];

    meta = with lib; {
      homepage = "https://pypi.python.org/pypi/enum34";
      description = "Python 3.4 Enum backported to 3.3, 3.2, 3.1, 2.7, 2.6, 2.5, and 2.4";
      license = licenses.bsd0;
    };
  }
