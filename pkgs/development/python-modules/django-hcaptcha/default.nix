{
  lib,
  buildPythonPackage,
  fetchPypi,
  django,
}:

buildPythonPackage (finalAttrs: {
  pname = "django-hcaptcha";
  version = "0.2.0";
  format = "setuptools";

  src = fetchPypi {
    inherit (finalAttrs) version;
    pname = "django-hCaptcha";
    hash = "sha256-slGerwzJeGWscvglMBEixc9h4eSFLWiVmUFgIirLbBo=";
  };

  propagatedBuildInputs = [ django ];

  # No tests
  doCheck = false;

  pythonImportsCheck = [ "hcaptcha" ];

  meta = {
    description = "Django hCaptcha provides a simple way to protect your django forms using hCaptcha";
    homepage = "https://github.com/AndrejZbin/django-hcaptcha";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ ambroisie ];
  };
})
