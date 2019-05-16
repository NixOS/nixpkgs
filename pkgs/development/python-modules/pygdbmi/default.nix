{ lib
, buildPythonPackage
, fetchFromGitHub
, gdb
}:

buildPythonPackage rec {
  pname = "pygdbmi";
  version = "0.9.0.0";

  src = fetchFromGitHub {
    #inherit pname version;
    #inherit pname version;
    owner = "cs01";
    repo = "pygdbmi";
    rev = version;
    sha256 = "12xq9iajgqz23dska5x63hrx75icr5bwwswnmba0y69y39s0jpsj";
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
