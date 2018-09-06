{ lib, buildPythonPackage, fetchPypi, aiohttp, jinja2, pytest, pytest-aiohttp }:

buildPythonPackage rec {
  pname = "aiohttp-jinja2";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "df1ba60b8779d232a23e5e38589b85f6430e9ace5adce546353155349bdea023";
  };

  propagatedBuildInputs = [ aiohttp jinja2 ];

  checkInputs = [ pytest pytest-aiohttp ];

  checkPhase = ''
    py.test
  '';

  meta = with lib; {
    description = "Jinja2 support for aiohttp";
    homepage = https://github.com/aio-libs/aiohttp_jinja2;
    license = licenses.asl20;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
