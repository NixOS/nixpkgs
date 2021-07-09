{ lib, buildPythonPackage, fetchPypi, pythonOlder
, aiohttp, webargs, apispec3, jinja2
}:

buildPythonPackage rec {
  pname = "aiohttp-apispec";
  version = "2.2.1";
  disabled = pythonOlder "3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0hhlmh3mc3xg68znsxyhypb5k12vg59yf72qkyw6ahg8zy3qfz2m";
  };

  propagatedBuildInputs = [ aiohttp webargs apispec3 jinja2 ];

  # No idea how to run the tests
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
