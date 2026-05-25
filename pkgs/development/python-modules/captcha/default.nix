{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  pillow,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "captcha";
  version = "0.7.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lepture";
    repo = "captcha";
    tag = "v${version}";
    hash = "sha256-wMnfPkHexiRprtDL6Kkmh9dms4NtW3u37DKtDMPb2ZI=";
  };

  dependencies = [ pillow ];

  nativeBuildInputs = [ setuptools ];

  pythonImportsCheck = [ "captcha" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Captcha library that generates audio and image CAPTCHAs";
    homepage = "https://github.com/lepture/captcha";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ Flakebi ];
  };
}
