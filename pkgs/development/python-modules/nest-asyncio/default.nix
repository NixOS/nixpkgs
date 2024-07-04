{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "nest-asyncio";
  version = "1.6.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "erdewit";
    repo = "nest_asyncio";
    rev = "refs/tags/v${version}";
    hash = "sha256-5I5WItOl1QpyI4OXZgZf8GiQ7Jlo+SJbDicIbernaU4=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "nest_asyncio" ];

  meta = with lib; {
    description = "Patch asyncio to allow nested event loops";
    homepage = "https://github.com/erdewit/nest_asyncio";
    changelog = "https://github.com/erdewit/nest_asyncio/releases/tag/v${version}";
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ ];
  };
}
