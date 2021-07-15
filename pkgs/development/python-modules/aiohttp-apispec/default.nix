{ lib, buildPythonPackage, fetchPypi, pythonOlder
, aiohttp, webargs5, apispec3, jinja2
}:

buildPythonPackage rec {
  pname = "aiohttp-apispec";
  version = "2.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0hhlmh3mc3xg68znsxyhypb5k12vg59yf72qkyw6ahg8zy3qfz2m";
  };

  propagatedBuildInputs = [ aiohttp webargs5 apispec3 jinja2 ];

  # The tests are not included in the archive from pypi
  doCheck = false;

  pythonImportsCheck = [
    "aiohttp_apispec"
  ];

  meta = with lib; {
    description = "Build and document REST APIs with aiohttp and apispec";
    homepage = "https://github.com/maximdanilchenko/aiohttp-apispec/";
    license = licenses.mit;
    maintainers = [ maintainers.viric ];
  };
}
