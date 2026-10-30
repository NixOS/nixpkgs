{
  lib,
  fetchFromGitHub,
  buildPythonPackage,

  # build-system
  hatchling,

  # dependencies
  beautifulsoup4,
  httpx,
  pbkdf2,
  pillow,
  pyaes,
  pyasn1,
  rsa,

  # test dependencies
  git-cliff,
  gitMinimal,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "audible";
  version = "0.13.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mkb79";
    repo = "Audible";
    tag = "v${version}";
    hash = "sha256-fXy9DNDguZgVklm8oG0iP9gaFfFGsjTdUpFMBt2arUc=";
  };

  pythonRelaxDeps = [ "rsa" ];

  build-system = [ hatchling ];

  dependencies = [
    beautifulsoup4
    httpx
    pbkdf2
    pillow
    pyaes
    pyasn1
    rsa
  ];

  nativeCheckInputs = [
    git-cliff
    gitMinimal
    pytestCheckHook
  ];

  pythonImportsCheck = [ "audible" ];

  meta = {
    description = "A(Sync) Interface for internal Audible API written in pure Python";
    license = lib.licenses.agpl3Only;
    homepage = "https://github.com/mkb79/Audible";
    maintainers = with lib.maintainers; [ jvanbruegge ];
  };
}
