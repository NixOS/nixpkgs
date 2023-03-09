{ stdenv
, lib
, buildPythonPackage
, fetchFromGitHub
, gdb
}:

buildPythonPackage rec {
  pname = "pygdbmi";
  version = "0.10.0.0";

  src = fetchFromGitHub {
    owner = "cs01";
    repo = "pygdbmi";
    rev = version;
    sha256 = "0a6b3zyxwdcb671c6lrwxm8fhvsbjh0m8hf1r18m9dha86laimjr";
  };

  nativeCheckInputs = [ gdb ];

  # tests require gcc for some reason
  doCheck = !stdenv.hostPlatform.isDarwin;

  postPatch = ''
    # tries to execute flake8,
    # which is likely to break on flake8 updates
    echo "def main(): return 0" > tests/static_tests.py
  '';

  meta = with lib; {
    description = "Parse gdb machine interface output with Python";
    homepage = "https://github.com/cs01/pygdbmi";
    license = licenses.mit;
    maintainers = [ maintainers.mic92 ];
  };
}
