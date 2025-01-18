{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pythonOlder,
  numpy,
  scipy,
}:

buildPythonPackage rec {
  pname = "reverse-geocode";
  version = "1.6.5";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchPypi {
    pname = "reverse_geocode";
    inherit version;
    hash = "sha256-AyqkLnbHa8ZylVfrJHpsxLeBfLTl6u9IQ3EV8grXrkE=";
  };

  build-system = [ setuptools ];

  dependencies = [
    numpy
    scipy
  ];

  #
  doCheck = false;

  pythonImportsCheck = [ "reverse_geocode" ];

  meta = with lib; {
    description = "Reverse geocode the given latitude/longitude";
    homepage = "https://pypi.org/project/reverse-geocode/";
    license = licenses.lgpl2Only;
    maintainers = with maintainers; [ fab ];
  };
}
