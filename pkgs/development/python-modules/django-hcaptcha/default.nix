{ lib, buildPythonPackage, fetchPypi, django, isPy27 }:

buildPythonPackage rec {
  pname = "django-hCaptcha";
  version = "0.2.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "06kcrcm24q21k6anhbc5wkhn3ky5488k09gqfan6ay691jprwldj";
  };

  # Requires hCaptcha credentials
  doCheck = false;

  propagatedBuildInputs = [ django ];

  meta = with lib; {
    description = "Provides a simple way to protect your django forms using hCaptcha.";
    homepage = "https://github.com/AndrejZbin/django-hcaptcha";
    maintainers = with maintainers; [ mrmebelman ];
    license = licenses.bsd3;
  };
}
