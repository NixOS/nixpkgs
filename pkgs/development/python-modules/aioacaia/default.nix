{
  lib,
  bleak,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "aioacaia";
  version = "0.1.14";
  pyproject = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "zweckj";
    repo = "aioacaia";
    tag = "v${version}";
    hash = "sha256-246/chGOaBlhEsoRcplWhRWvmaYgk6stRVqU+Crh+Kw=";
  };

  build-system = [ setuptools ];

  dependencies = [ bleak ];

  # Module only has a homebrew tests
  doCheck = false;

  pythonImportsCheck = [ "aioacaia" ];

  meta = {
    description = "Async implementation of pyacaia";
    homepage = "https://github.com/zweckj/aioacaia";
    changelog = "https://github.com/zweckj/aioacaia/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
  };
}
