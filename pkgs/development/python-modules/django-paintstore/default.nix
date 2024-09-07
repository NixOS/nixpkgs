{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "django-paintstore";
  version = "0.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "12wxgwv1qbkfq7w5i7bm7aidv655c2sxp0ym73qf8606dxbjcwwg";
  };

  doCheck = false;

  meta = with lib; {
    description = "Django app that integrates jQuery ColorPicker with the Django admin";
    homepage = "https://github.com/gsiegman/django-paintstore";
    license = licenses.mit;
  };
}
