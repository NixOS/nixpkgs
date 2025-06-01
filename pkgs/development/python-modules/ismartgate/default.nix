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
  version = "5.0.2";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "bdraco";
    repo = "ismartgate";
    tag = "v${version}";
    hash = "sha256-8c05zzDav87gTL2CI7Aoi6ALwLw76H9xj+90xH31hdE=";
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
