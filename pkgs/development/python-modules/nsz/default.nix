{ lib
, buildPythonPackage
, fetchFromGitHub
, pycryptodome
, pythonOlder
, enlighten
, zstandard
, withGUI ? true
, kivy
}:

buildPythonPackage rec {
  pname = "nsz";
  version = "4.4.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "nicoboss";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-glK4CK7D33FfLqHLxVr4kkb887/A9tqxPwWpcXYZu/0=";
  };

  propagatedBuildInputs = [
    pycryptodome
    enlighten
    zstandard
  ] ++ lib.optional withGUI kivy;

  # do not check, as nsz requires producation keys
  # dumped from a Nintendo Switch.
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/nicoboss/nsz";
    description = "Homebrew compatible NSP/XCI compressor/decompressor";
    changelog = "https://github.com/nicoboss/nsz/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ eyjhb ];
  };
}
