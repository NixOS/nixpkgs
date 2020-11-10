{ lib, buildPythonPackage, fetchFromGitHub, humanfriendly, pytest, pytestcov }:

buildPythonPackage rec {
  pname = "capturer";
  version = "3.0";

  src = fetchFromGitHub {
    owner = "xolox";
    repo = "python-capturer";
    rev = version;
    sha256 = "0fwrxa049gzin5dck7fvwhdp1856jrn0d7mcjcjsd7ndqvhgvjj1";
  };

  propagatedBuildInputs = [ humanfriendly ];

  checkPhase = ''
    PATH=$PATH:$out/bin pytest .
  '';
  checkInputs = [ pytest ];

  meta = with lib; {
    description = "Easily capture stdout/stderr of the current process and subprocesses";
    homepage = "https://github.com/xolox/python-capturer";
    license = licenses.mit;
    maintainers = with maintainers; [ eyjhb ];
  };
}
