{
  lib,
  buildPythonPackage,
  colorama,
  django,
  fetchFromGitHub,
  flask-unsign,
  poetry-core,
  poetry-dynamic-versioning,
  pycryptodome,
  pyjwt,
  requests,
  viewstate,
}:

buildPythonPackage rec {
  pname = "badsecrets";
  version = "0.11.118";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "blacklanternsecurity";
    repo = "badsecrets";
    tag = "v${version}";
    hash = "sha256-7jKhXFrtZI+Xzs7R8E3zJNN3wTEkuTuhc3PGn6JOzTU=";
  };

  build-system = [
    poetry-core
    poetry-dynamic-versioning
  ];

  dependencies = [
    colorama
    django
    flask-unsign
    pycryptodome
    pyjwt
    requests
    viewstate
  ];

  pythonImportsCheck = [ "badsecrets" ];

  meta = {
    description = "Module for detecting known secrets across many web frameworks";
    homepage = "https://github.com/blacklanternsecurity/badsecrets";
    changelog = "https://github.com/blacklanternsecurity/badsecrets/releases/tag/${src.tag}";
    license = with lib.licenses; [
      agpl3Only
      gpl3Only
    ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
