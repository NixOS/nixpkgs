{
  lib,
  argon2-cffi,
  buildPythonPackage,
  dissect-cstruct,
  dissect-util,
  dissect-target,
  fetchFromGitHub,
  pycryptodome,
  pythonOlder,
  rich,
  setuptools-scm,
  setuptools,
}:

buildPythonPackage rec {
  pname = "dissect-fve";
  version = "4.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "dissect.fve";
    tag = version;
    hash = "sha256-xPjwyI134E0JWkM+S2ae9TuBGHMSrgyjooM9CGECqgg=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    argon2-cffi
    dissect-cstruct
    dissect-util
    pycryptodome
  ];

  optional-dependencies = {
    full = [
      dissect-target
      rich
    ];
  };

  pythonImportsCheck = [ "dissect.fve" ];

  meta = with lib; {
    description = "Dissect module implementing parsers for full volume encryption implementations";
    homepage = "https://github.com/fox-it/dissect.fve";
    changelog = "https://github.com/fox-it/dissect.fve/releases/tag/${src.tag}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
