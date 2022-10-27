{ lib
, buildPythonPackage
, fetchFromGitHub

# native
, poetry-core

# propagated
, blessed
, python-editor
, readchar

# tests
, pytest-mock
, pytestCheckHook
, pexpect
}:

buildPythonPackage rec {
  pname = "inquirer";
  version = "2.9.2";
  format = "pyproject";

  src = fetchFromGitHub rec {
    owner = "magmax";
    repo = "python-inquirer";
    rev = "v${version}";
    sha256 = "sha256-TQEZeZDl4N78dE7CXy5OwquUoHuxxjmDAC3wdxqydaQ=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    blessed
    python-editor
    readchar
  ];

  checkInputs = [
    pexpect
    pytest-mock
    pytestCheckHook
  ];

  meta = with lib; {
    homepage = "https://github.com/magmax/python-inquirer";
    description = "A collection of common interactive command line user interfaces, based on Inquirer.js";
    license = licenses.mit;
    maintainers = [ maintainers.mmahut ];
  };
}
