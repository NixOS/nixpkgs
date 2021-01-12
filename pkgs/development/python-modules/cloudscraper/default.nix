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
  version = "1.2.52";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "07j2nhzimzhcskj2wpxpvpb3dhpci19daw02r2ckkjiq3zifhm6v";
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
    homepage = https://github.com/venomous/cloudscraper;
    license = licenses.mit;
    maintainers = with maintainers; [ kini ];
  };
}
