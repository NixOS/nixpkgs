{ lib
, buildPythonPackage
, fetchFromGitHub
, unittestCheckHook

, lxml
, requests
}:

buildPythonPackage rec {
  pname = "free_proxy";
  version = "1.1.0";

  # Pypi does not contain tests
  src = fetchFromGitHub {
    owner = "jundymek";
    repo = "free-proxy";
    rev = version;
    sha256 = "sha256-BxhhTAKNeuPa07jP+5G7saED5DO5ZQlhcvwGXAN0+5Y=";
  };

  propagatedBuildInputs = [
    lxml
    requests
  ];

  checkPhase = ''
    python test_proxy.py
  '';

  meta = with lib; {
    homepage = "https://github.com/jundymek/free-proxy";
    description = "Free proxy scraper written in python";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ pkosel ];
  };
}
