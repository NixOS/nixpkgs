{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, typing-extensions
, pytestCheckHook
, pytest-asyncio
}:

buildPythonPackage rec {
  pname = "async-lru";
  version = "2.0.0";

  disabled = pythonOlder "3.8";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "aio-libs";
    repo = "async-lru";
    rev = "v${version}";
    hash = "sha256-mCmEMN9D6kEkHb3GoYuVk4XxvhaSX5eOHqpKawrcoxs=";
  };

  propagatedBuildInputs = [
    typing-extensions
  ];

  postPatch = ''
    sed -i -e '/^addopts/d' -e '/^filterwarnings/,+2d' setup.cfg
  '';

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
  ];

  pythonImportsCheck = [ "async_lru" ];

  meta = with lib; {
    description = "Simple lru cache for asyncio";
    homepage = "https://github.com/wikibusiness/async_lru";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
