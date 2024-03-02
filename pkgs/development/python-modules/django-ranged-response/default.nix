{ lib, fetchPypi, buildPythonPackage, django }:

buildPythonPackage rec {
  pname = "django-ranged-response";
  version = "0.2.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "11gr3jpmb5rvg3scv026kjwwkmnxwivgq5ypxadnnc9p58szy7zp";
  };

  # tests not included in PyPi package, github source is not up to date with 0.2.0
  doCheck = false;

  propagatedBuildInputs = [ django ];

  meta = with lib; {
    description = "A modified FileResponse that returns `Content-Range` headers with the HTTP response, so browsers (read Safari 9+) that request the file, can stream the response properly";
    homepage = "https://github.com/wearespindle/django-ranged-fileresponse";
    license = licenses.mit;
    maintainers = with maintainers; [ mrmebelman ];
  };
}
