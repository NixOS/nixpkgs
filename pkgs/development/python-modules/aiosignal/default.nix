{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  frozenlist,
  pytest-asyncio,
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
    repo = pname;
    rev = "v${version}";
    hash = "sha256-CvNarJpSq8EKnt+PuSerMK/ZVbxL9rp7rQ4dkWykG1M=";
  };

  propagatedBuildInputs = [ frozenlist ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "filterwarnings = error" "" \
      --replace "--cov=aiosignal" ""
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
