{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, pillow
, nose
}:

buildPythonPackage rec {
  pname = "captcha";
  version = "0.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-KuXo2qxPFkm1ezQyi8xFumkbXHB/xvvdAW4hOuzpqLg=";
  };

  checkInputs = [ nose ];
  propagatedBuildInputs = [ setuptools pillow ];

  meta = with lib; {
    description = "A captcha library that generates audio and image CAPTCHAs.";
    homepage = "https://github.com/lepture/captcha";
    license = licenses.bsd3;
    maintainers = with maintainers; [ MrMebelMan ];
  };
}
