{ lib
, buildPythonPackage
, fetchPypi
, six
, pytest
}:

buildPythonPackage rec {
  pname = "Protego";
  version = "0.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-32ZtQwTat3Ti3J/rIIuxrI1x6lzuwS9MmeujD71kL/I=";
  };
  propagatedBuildInputs = [ six ];

  nativeCheckInputs = [ pytest ];

  checkPhase = ''
    pytest tests
  '';

  meta = with lib; {
    description = "A pure-Python robots.txt parser with support for modern conventions";
    homepage = "https://github.com/scrapy/protego";
    license = licenses.bsd3;
    maintainers = [ maintainers.marsam ];
  };
}
