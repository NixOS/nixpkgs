{
  lib,
  buildPythonPackage,
  click,
  defusedxml,
  dicttoxml,
  fetchFromGitHub,
  httpx,
  pycryptodome,
  pytest-asyncio,
  pytest-raises,
  pytestCheckHook,
  pythonOlder,
  respx,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "ismartgate";
  version = "5.0.1";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "bdraco";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-mfiHoli0ldw/E1SrtOBpDO8ZTC0wTeaoSZ2nPnx5EaQ=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace '"pytest-runner>=5.2",' ""
  '';

  propagatedBuildInputs = [
    click
    defusedxml
    dicttoxml
    httpx
    pycryptodome
    typing-extensions
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-raises
    pytestCheckHook
    respx
  ];

  pythonImportsCheck = [ "ismartgate" ];

  meta = with lib; {
    description = "Python module to work with the ismartgate and gogogate2 API";
    homepage = "https://github.com/bdraco/ismartgate";
    changelog = "https://github.com/bdraco/ismartgate/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
