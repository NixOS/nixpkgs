{ lib, buildPythonPackage, fetchFromGitHub, pycryptodome, enlighten, zstandard
, withGUI ? true
, kivy
}:

buildPythonPackage rec {
  pname = "nsz";
  version = "4.2.1";

  src = fetchFromGitHub {
    owner = "nicoboss";
    repo = pname;
    rev = "refs/tags/${version}";
    sha256 = "sha256-It815Uxxs4T9BM9EypAfPuq4Oy8rgGLpKA79m2xM8N4=";
  };

  propagatedBuildInputs = [pycryptodome enlighten zstandard ]
    ++ lib.optional withGUI kivy;

  # do not check, as nsz requires producation keys
  # dumped from a Nintendo Switch.
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/nicoboss/nsz";
    description = "NSZ - Homebrew compatible NSP/XCI compressor/decompressor";
    license = licenses.mit;
    maintainers = with maintainers; [ eyjhb ];
  };
}
