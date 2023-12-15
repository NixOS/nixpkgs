{ lib
, buildPythonPackage
, fetchFromGitHub
, docutils
, python
, pygments
, setuptools
, requests
}:

buildPythonPackage rec {
  pname = "pyroma";
  version = "3.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "regebro";
    repo = pname;
    rev = version;
    sha256 = "0ln9w984n48nyxwzd1y48l6b18lnv52radcyizaw56lapcgxrzdr";
  };

  propagatedBuildInputs = [
    docutils
    pygments
    setuptools
    requests
  ];

  # https://github.com/regebro/pyroma/blob/3.2/Makefile#L23
  # PyPITest requires network access
  checkPhase = ''
    ${python.interpreter} -m unittest -k 'not PyPITest' pyroma.tests
  '';

  pythonImportsCheck = [ "pyroma" ];

  meta = with lib; {
    description = "Test your project's packaging friendliness";
    homepage = "https://github.com/regebro/pyroma";
    license = licenses.mit;
    maintainers = with maintainers; [ kamadorueda ];
  };
}
