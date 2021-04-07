{ lib
, buildPythonPackage
, isPy3k
, fetchPypi
, requests
, requests-toolbelt
, pyparsing
}:

buildPythonPackage rec {
  pname = "cloudscraper";
  version = "1.2.56";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "84c5910023dd393619b2b793fdb154392c5c8887b55e4bcac3ad2646f1cfe212";
  };

  propagatedBuildInputs = [
    requests
    requests-toolbelt
    pyparsing
  ];

  # The tests require several other dependencies, some of which aren't in
  # nixpkgs yet, and also aren't included in the PyPI bundle.  TODO.
  doCheck = false;

  pythonImportsCheck = [ "cloudscraper" ];

  meta = with lib; {
    description = "A Python module to bypass Cloudflare's anti-bot page";
    homepage = "https://github.com/venomous/cloudscraper";
    license = licenses.mit;
    maintainers = with maintainers; [ kini ];
  };
}
