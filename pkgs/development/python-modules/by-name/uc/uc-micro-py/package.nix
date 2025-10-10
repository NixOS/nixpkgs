{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "uc-micro-py";
  version = "1.0.3";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "tsutsu3";
    repo = "uc.micro-py";
    tag = "v${version}";
    hash = "sha256-Z7XHWeV5I/y19EKg4lzcl9pwRexWnSQ7d8CpQu5xdnI=";
  };

  nativeBuildInputs = [ setuptools ];

  pythonImportsCheck = [ "uc_micro" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Micro subset of unicode data files for linkify-it-py";
    homepage = "https://github.com/tsutsu3/uc.micro-py";
    license = licenses.mit;
    maintainers = [ ];
  };
}
