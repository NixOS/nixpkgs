{ lib
, buildPythonPackage
, fetchFromGitHub
, gdb
}:

buildPythonPackage rec {
  pname = "pygdbmi";
  version = "0.9.0.2";

  src = fetchFromGitHub {
    #inherit pname version;
    #inherit pname version;
    owner = "cs01";
    repo = "pygdbmi";
    rev = version;
    sha256 = "01isx7912dbalmc3xsafk1a1n6bzzfrjn2363djcq0v57rqii53d";
  };

  checkInputs = [ gdb ];

  postPatch = ''
    # tries to execute flake8,
    # which is likely to break on flake8 updates
    echo "def main(): return 0" > tests/static_tests.py
  '';

  meta = with lib; {
    description = "Parse gdb machine interface output with Python";
    homepage = https://github.com/cs01/pygdbmi;
    license = licenses.mit;
    maintainers = [ maintainers.mic92 ];
  };
}
