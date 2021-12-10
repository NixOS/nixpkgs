{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, sgmllib3k
}:

buildPythonPackage rec {
  pname = "feedparser";
  version = "6.0.8";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
     owner = "kurtmckee";
     repo = "feedparser";
     rev = "6.0.8";
     sha256 = "0qdaakqv3k23gl8r1w3lzn6hlnx0fm5sild6kp11iziz25dgbwzd";
  };

  propagatedBuildInputs = [ sgmllib3k ];

  checkPhase = ''
    python -Wd tests/runtests.py
  '';

  pythonImportsCheck = [ "feedparser" ];

  meta = with lib; {
    homepage = "https://github.com/kurtmckee/feedparser";
    description = "Universal feed parser";
    license = licenses.bsd2;
    maintainers = with maintainers; [ domenkozar ];
  };
}
