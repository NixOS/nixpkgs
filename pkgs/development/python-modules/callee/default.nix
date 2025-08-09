{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "callee";
  version = "0.3.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Xion";
    repo = "callee";
    tag = version;
    hash = "sha256-dsXMY3bW/70CmTfCuy5KjxPa+NLCzxzWv5e1aV2NEWE=";
  };

  pythonImportsCheck = [ "callee" ];

  doCheck = false; # missing dependency

  nativeCheckInputs = [
    # taipan missing, unmaintained, not python3.10 compatible
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Argument matchers for unittest.mock";
    homepage = "https://github.com/Xion/callee";
    license = licenses.bsd3;
    maintainers = with maintainers; [ hexa ];
  };
}
