{ lib, buildPythonPackage, fetchurl, django }:

buildPythonPackage rec {
  pname = "django-recaptcha";
  version = "3.0.0";

  src = fetchurl {
    url = "https://github.com/torchbox/django-recaptcha/archive/refs/tags/${version}.tar.gz";
    sha256 = "sha256-oHOPzGPjlE5c0GWPwlBFaPrWE/GqEHPCDCyDcoNsIOk=";
  };

  propagatedBuildInputs = [ django ];

  doCheck = false; # Requires ReCaptcha account

  meta = with lib; {
    description = "Django reCAPTCHA form field/widget integration app.";
    homepage = "https://github.com/torchbox/django-recaptcha";
    license = licenses.bsd3;
    maintainers = with maintainers; [];
  };
}

