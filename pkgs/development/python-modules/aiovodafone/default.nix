{
  lib,
  aiohttp,
  beautifulsoup4,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "aiovodafone";
  version = "0.6.0";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "chemelli74";
    repo = "aiovodafone";
    rev = "refs/tags/v${version}";
    hash = "sha256-sy7/nCthmfI0WdBkwBU83fifcYTe9zUBOpxV7RX9F6w=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail " --cov=aiovodafone --cov-report=term-missing:skip-covered" ""
  '';

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    beautifulsoup4
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "aiovodafone" ];

  meta = with lib; {
    description = "Library to control Vodafon Station";
    homepage = "https://github.com/chemelli74/aiovodafone";
    changelog = "https://github.com/chemelli74/aiovodafone/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
