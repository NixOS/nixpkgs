{ stdenv
, lib
, buildPythonPackage
, fetchFromGitHub
, gdb
, pytest
}:

buildPythonPackage rec {
  pname = "pygdbmi";
  version = "0.11.0.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "cs01";
    repo = "pygdbmi";
    rev = "refs/tags/v${version}";
    hash = "sha256-JqEDN8Pg/JttyYQbwkxKkLYuxVnvV45VlClD23eaYyc=";
  };

  nativeCheckInputs = [ gdb pytest ];

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
