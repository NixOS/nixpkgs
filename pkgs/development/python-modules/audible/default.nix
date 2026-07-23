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
  rsa,
  cryptography,
  pycryptodome,
  orjson,
  ujson,
  python-rapidjson,

  # test dependencies
  pytestCheckHook,
  git,
  git-cliff,
}:

buildPythonPackage rec {
  pname = "audible";
  version = "0.12.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mkb79";
    repo = "Audible";
    tag = "v${version}";
    hash = "sha256-N13R6HQyfd3Q2cBvxjnVzCXtoW9JE54IMqBX5qgeteI=";
  };

  build-system = [ hatchling ];

  dependencies = [
    pillow
    beautifulsoup4
    httpx
    pbkdf2
    pyaes
    rsa
  ];

  optional-dependencies = {
    cryptography = [ cryptography ];
    pycryptodome = [ pycryptodome ];
    orjson = [ orjson ];
    ujson = [ ujson ];
    rapidjson = [ python-rapidjson ];
    json-fast = [ orjson ];
    json-full = [
      orjson
      ujson
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    git
    git-cliff
  ];

  pythonImportsCheck = [ "audible" ];

  meta = {
    description = "A(Sync) Interface for internal Audible API written in pure Python";
    license = lib.licenses.agpl3Only;
    homepage = "https://github.com/mkb79/Audible";
    maintainers = with lib.maintainers; [ jvanbruegge ];
  };
}
