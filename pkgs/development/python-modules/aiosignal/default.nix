{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  frozenlist,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "aiosignal";
  version = "1.3.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "aio-libs";
    repo = "aiosignal";
    rev = "v${version}";
    hash = "sha256-CvNarJpSq8EKnt+PuSerMK/ZVbxL9rp7rQ4dkWykG1M=";
  };

  propagatedBuildInputs = [ frozenlist ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "filterwarnings = error" ""
  '';

  pythonImportsCheck = [ "aiosignal" ];

  meta = with lib; {
    description = "Python list of registered asynchronous callbacks";
    homepage = "https://github.com/aio-libs/aiosignal";
    changelog = "https://github.com/aio-libs/aiosignal/blob/v${version}/CHANGES.rst";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
