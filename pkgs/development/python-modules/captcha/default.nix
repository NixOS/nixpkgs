{
  lib,
  fetchFromGitHub,
  pythonOlder,
  buildPythonPackage,
  pillow,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "captcha";
  version = "0.5.0";

  disabled = pythonOlder "3.8";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "lepture";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-TPPuf0BRZPSHPSF0HuGxhjhoSyZQ7r86kSjkrztgZ5w=";
  };

  propagatedBuildInputs = [ pillow ];

  pythonImportsCheck = [ "captcha" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "A captcha library that generates audio and image CAPTCHAs";
    homepage = "https://github.com/lepture/captcha";
    license = licenses.bsd3;
    maintainers = with maintainers; [ Flakebi ];
  };
}
