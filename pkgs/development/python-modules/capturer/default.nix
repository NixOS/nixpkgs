{ lib, buildPythonPackage, fetchFromGitHub, humanfriendly, pytest, pytestcov }:

buildPythonPackage rec {
  pname = "capturer";
  version = "2.4";

  src = fetchFromGitHub {
    owner = "xolox";
    repo = "python-capturer";
    rev = version;
    sha256 = "07zy264xd0g7pz9sxjqcpwmrck334xcbb7wfss26lmvgdr5nhcb9";
  };

  propagatedBuildInputs = [ humanfriendly ];

  checkPhase = ''
    PATH=$PATH:$out/bin pytest .
  '';
  checkInputs = [ pytest ];

  meta = with lib; {
    description = "Easily capture stdout/stderr of the current process and subprocesses";
    homepage = https://github.com/xolox/python-capturer;
    license = licenses.mit;
    maintainers = with maintainers; [ eyjhb ];
  };
}
