{ lib
, buildPythonPackage
, fetchFromGitHub
, re2
}:

buildPythonPackage rec {
  pname = "fb-re2";
  version = "1.0.7";

  src = fetchFromGitHub {
     owner = "facebook";
     repo = "pyre2";
     rev = "v1.0.7";
     sha256 = "0snprxdnh3m45r3b0az4v0l28h90ycmfbybzla6xg1qviwv9w1ak";
  };

  buildInputs = [ re2 ];

  # no tests in PyPI tarball
  doCheck = false;

  meta = {
    description = "Python wrapper for Google's RE2";
    homepage = "https://github.com/facebook/pyre2";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ ivan ];
  };
}
