{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  importlib-metadata,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "chameleon";
  version = "4.5.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "malthe";
    repo = "chameleon";
    rev = "refs/tags/${version}";
    hash = "sha256-TbXx3reRpUqnMVDsr38FM1SLgARjqXAduO3k87U5TIg=";
  };

  build-system = [ setuptools ];

  dependencies = lib.optionals (pythonOlder "3.10") [ importlib-metadata ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "chameleon" ];

  meta = with lib; {
    changelog = "https://github.com/malthe/chameleon/blob/${version}/CHANGES.rst";
    description = "Fast HTML/XML Template Compiler";
    downloadPage = "https://github.com/malthe/chameleon";
    homepage = "https://chameleon.readthedocs.io";
    license = licenses.bsd0;
    maintainers = with maintainers; [ domenkozar ];
  };
}
