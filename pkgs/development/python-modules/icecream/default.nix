{ lib, buildPythonPackage, fetchPypi
, asttokens, colorama, executing, pygments
}:

buildPythonPackage rec {
  pname = "icecream";
  version = "2.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "16kpixl43nrn093cvkmxiq2dzd9xc73zwzkmwp0rs7x01nji8kj3";
  };

  propagatedBuildInputs = [ asttokens colorama executing pygments ];

  meta = with lib; {
    description = "A little library for sweet and creamy print debugging";
    homepage = "https://github.com/gruns/icecream";
    license = licenses.mit;
    maintainers = with maintainers; [ renatoGarcia ];
  };
}
