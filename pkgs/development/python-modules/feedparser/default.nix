{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, sgmllib3k
}:

buildPythonPackage rec {
  pname = "feedparser";
  version = "6.0.8";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-XOBBCgWrJIyMfPyjoOoiA5aO6f9EhgZzea9IJ6WflmE=";
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
