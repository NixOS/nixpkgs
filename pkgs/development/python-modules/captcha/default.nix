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
  version = "0.6.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "lepture";
    repo = "captcha";
    rev = "refs/tags/v${version}";
    hash = "sha256-5d5gts+BXS5OKVziR9cLczsD2QMXZ/n31sPEq+gPlxk=";
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
