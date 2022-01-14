{ lib, buildPythonPackage, fetchFromGitHub, python-editor, readchar, blessed, pytest, pytest-cov, pexpect, pytest-mock }:

buildPythonPackage rec {
  pname = "inquirer";
  version = "2.9.1";

  # PyPi archive currently broken: https://github.com/magmax/python-inquirer/issues/106
  src = fetchFromGitHub rec {
    owner = "magmax";
    repo = "python-inquirer";
    rev = version;
    sha256 = "0vdly2k4i7bfcqc8zh2miv9dbpmqvayxk72qn9d4hr7z15wph233";
  };

  propagatedBuildInputs = [ blessed python-editor readchar ];

  postPatch = ''
   substituteInPlace requirements.txt \
     --replace "blessed==1.17.6" "blessed~=1.17" \
     --replace "readchar==2.0.1" "readchar>=2.0.0"
  '';

  checkInputs = [ pytest pytest-cov pexpect pytest-mock ];

  checkPhase = ''
    pytest --cov-report=term-missing  --cov inquirer --no-cov-on-fail tests/unit tests/integration
  '';

  meta = with lib; {
    homepage = "https://github.com/magmax/python-inquirer";
    description = "A collection of common interactive command line user interfaces, based on Inquirer.js";
    license = licenses.mit;
    maintainers = [ maintainers.mmahut ];
  };
}
