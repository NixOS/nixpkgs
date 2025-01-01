{
  lib,
  buildPythonPackage,
  django,
  fetchPypi,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "django-admin-datta";
  version = "1.0.15";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-QVobNrSZyDMldrhSccPnBEfXrwphVgtJ03yBHfTpits=";
  };

  propagatedBuildInputs = [ django ];

  # no tests
  doCheck = false;

  pythonImportsCheck = [ "admin_datta" ];

  meta = with lib; {
    description = "Modern template for Django that covers Admin Section";
    homepage = "https://appseed.us/product/datta-able/django";
    changelog = "https://github.com/app-generator/django-admin-datta/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ derdennisop ];
  };
}
