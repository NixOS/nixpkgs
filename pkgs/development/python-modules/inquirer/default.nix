{ stdenv, buildPythonPackage, fetchPypi, python-editor, readchar, blessings, pytest, pytestcov, pexpect, pytest-mock }:

buildPythonPackage rec {
  pname = "inquirer";
  version = "2.6.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "01lf51y3bxsxkghbdk9hr42yvihpwi2s5zpxnra3bx41r35msvjz";
  };

  propagatedBuildInputs = [ python-editor readchar blessings ];

  # No real changes in 2.0.0...e0edfa3
  postPatch = ''
   substituteInPlace setup.py \
     --replace "readchar == 2.0.1" "readchar >= 2.0.0"
  '';

  checkInputs = [ pytest pytestcov pexpect pytest-mock ];

  checkPhase = ''
    pytest --cov-report=term-missing  --cov inquirer --no-cov-on-fail tests/unit tests/integration
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/magmax/python-inquirer";
    description = "A collection of common interactive command line user interfaces, based on Inquirer.js";
    license = licenses.mit;
    maintainers = [ maintainers.mmahut ];
  };
}
