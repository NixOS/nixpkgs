{
  lib,
  fetchFromGitHub,
  pythonOlder,
  buildPythonPackage,
  pillow,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "captcha";
  version = "0.7.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "lepture";
    repo = "captcha";
    tag = "v${version}";
    hash = "sha256-cZI9LSX/FH3bKL3DKDObNZP0D0n5hSD/lhV19ageMXY=";
  };

  dependencies = [ pillow ];

  nativeBuildInputs = [ setuptools ];

  pythonImportsCheck = [ "captcha" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Captcha library that generates audio and image CAPTCHAs";
    homepage = "https://github.com/lepture/captcha";
    license = licenses.bsd3;
    maintainers = with maintainers; [ Flakebi ];
  };
}
