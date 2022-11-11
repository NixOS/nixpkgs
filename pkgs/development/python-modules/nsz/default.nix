{ lib, buildPythonPackage, fetchFromGitHub, pycryptodome, enlighten, zstandard
, withGUI ? true
, kivy
}:

buildPythonPackage rec {
  pname = "nsz";
  version = "4.1.0";

  src = fetchFromGitHub {
    owner = "nicoboss";
    repo = pname;
    rev = version;
    sha256 = "sha256-tdngXV+VUOAkg3lF2NOmw0mBeSEE+YpUfuKukTKcPnM=";
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
