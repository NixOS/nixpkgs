{ lib
, buildPythonPackage
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "pscript";
  version = "0.7.6";

  # PyPI tarball doesn't include tests directory
  src = fetchFromGitHub {
    owner = "flexxui";
    repo = pname;
    rev = "v${version}";
    sha256 = "169px5n4jjnpdn9y86f28qwd95bwf1q1rz0a1h3lb5nn5c6ym8c4";
  };

  doCheck = false;

  meta = with lib; {
    description = "Python to JavaScript compiler";
    license = licenses.bsd2;
    homepage = "https://pscript.readthedocs.io";
    maintainers = [ maintainers.matthiasbeyer ];
  };
}



