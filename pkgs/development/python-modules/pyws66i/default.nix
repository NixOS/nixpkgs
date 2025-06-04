{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonAtLeast,
  pythonOlder,
  standard-telnetlib,
}:

buildPythonPackage rec {
  pname = "pyws66i";
  version = "1.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ssaenger";
    repo = "pyws66i";
    rev = "v${version}";
    hash = "sha256-NTL2+xLqSNsz4YdUTwr0nFjhm1NNgB8qDnWSoE2sizY=";
  };

  dependencies = lib.optionals (pythonAtLeast "3.13") [ standard-telnetlib ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pyws66i" ];

  meta = with lib; {
    description = "Library to interface with WS66i 6-zone amplifier";
    homepage = "https://github.com/bigmoby/pyialarmxr";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
