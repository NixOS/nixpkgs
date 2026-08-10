{
  lib,
  blasthttp,
  buildPythonPackage,
  colorama,
  django,
  fetchFromGitHub,
  flask-unsign,
  hatchling,
  pycryptodome,
  pyjwt,
  requests,
  yara-python,
}:

buildPythonPackage (finalAttrs: {
  pname = "badsecrets";
  version = "1.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "blacklanternsecurity";
    repo = "badsecrets";
    tag = finalAttrs.version;
    hash = "sha256-I0CyY8FVFFPRBK04zZ1v2WSv4ovRATZmAWLGwE0Q4pQ=";
  };

  pythonRelaxDeps = [
    "django"
    "pyjwt"
  ];

  build-system = [ hatchling ];

  dependencies = [
    blasthttp
    colorama
    django
    flask-unsign
    pycryptodome
    pyjwt
    requests
    yara-python
  ]
  ++ pyjwt.optional-dependencies.crypto;

  pythonImportsCheck = [ "badsecrets" ];

  meta = {
    description = "Module for detecting known secrets across many web frameworks";
    homepage = "https://github.com/blacklanternsecurity/badsecrets";
    changelog = "https://github.com/blacklanternsecurity/badsecrets/releases/tag/${finalAttrs.src.tag}";
    license = with lib.licenses; [
      agpl3Only
      gpl3Only
    ];
    maintainers = with lib.maintainers; [ fab ];
  };
})
