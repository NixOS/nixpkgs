{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "docopt-ng";
  version = "0.7.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-hs7qAy8M+lnmB3brDPOKxzZTWBAihyMg9H3IdGeNckQ=";
  };

  pythonImportsCheck = [ "docopt" ];
  doCheck = false; # no tests in the package

  meta = with lib; {
    description = "More-magic command line arguments parser. Now with more maintenance!";
    homepage = "https://github.com/bazaar-projects/docopt-ng";
    license = licenses.mit;
    maintainers = with maintainers; [ fgaz ];
  };
}
