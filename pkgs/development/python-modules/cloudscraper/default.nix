{ lib
, buildPythonPackage
, isPy3k
, fetchFromGitHub
, requests
, requests-toolbelt
, pyparsing
}:

buildPythonPackage rec {
  pname = "cloudscraper";
  version = "1.2.58";
  disabled = !isPy3k;

  src = fetchFromGitHub {
     owner = "venomous";
     repo = "cloudscraper";
     rev = "1.2.58";
     sha256 = "18fbp086imabjxly04rrchbf6n6m05bpd150zxbw7z2w3mjnpsqd";
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
