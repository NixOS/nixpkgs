{ lib
, buildPythonPackage
, fetchPypi
, six
, pytest
}:

buildPythonPackage rec {
  pname = "Protego";
  version = "0.1.16";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a682771bc7b51b2ff41466460896c1a5a653f9a1e71639ef365a72e66d8734b4";
  };
  propagatedBuildInputs = [ six ];

  checkInputs = [ pytest ];

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
