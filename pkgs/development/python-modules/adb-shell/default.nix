{ aiofiles, buildPythonPackage, cryptography, fetchFromGitHub, isPy3k, lib
, libusb1, mock, pyasn1, python, pycryptodome, rsa }:

buildPythonPackage rec {
  pname = "adb-shell";
  version = "0.3.0";

  disabled = !isPy3k;

  # pypi does not contain tests, using github sources instead
  src = fetchFromGitHub {
    owner = "JeffLIrion";
    repo = "adb_shell";
    rev = "v${version}";
    sha256 = "0qnlhcd58zxh39cd5xzdx8yc5hc0pf8kix4rbn4avsapwb0l75n2";
  };

  propagatedBuildInputs = [ aiofiles cryptography libusb1 pyasn1 rsa ];

  checkInputs = [ mock pycryptodome ];
  checkPhase = ''
    ${python.interpreter} -m unittest discover -s tests -t .
  '';

  meta = with lib; {
    description =
      "A Python implementation of ADB with shell and FileSync functionality.";
    homepage = "https://github.com/JeffLIrion/adb_shell";
    license = licenses.asl20;
    maintainers = with maintainers; [ jamiemagee ];
  };
}
