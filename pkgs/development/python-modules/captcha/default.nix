{ lib
, fetchFromGitHub
, buildPythonPackage
, nose
, pillow
, wheezy-captcha
}:

buildPythonPackage rec {
  pname = "captcha";
  version = "0.4";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "lepture";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-uxUjoACN65Cx5LMKpT+bZhKpf2JRSaEyysnYUgZntp8=";
  };

  propagatedBuildInputs = [ pillow ];

  pythonImportsCheck = [ "captcha" ];

  nativeCheckInputs = [ nose wheezy-captcha ];

  checkPhase = ''
    nosetests -s
  '';

  meta = with lib; {
    description = "A captcha library that generates audio and image CAPTCHAs";
    homepage = "https://github.com/lepture/captcha";
    license = licenses.bsd3;
    maintainers = with maintainers; [ Flakebi ];
  };
}
