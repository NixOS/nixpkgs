{ lib, buildPythonPackage, fetchFromGitHub, numpy, pyserial, scipy
, pytest-mock, pytest, coverage}:

buildPythonPackage rec {
  pname = "pslab";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "fossasia";
    repo = "pslab-python";
    rev = "v" + version;
    sha256 = "12n2zdbgbhrnkgf1z7hlpvgl8zycvw3qxc6fhh1srkj6j2jwvr2n";
  };

  propagatedBuildInputs = [ numpy pyserial scipy ];
  checkInputs = [ pytest pytest-mock coverage ];

  # from tox.ini
  checkPhase = ''
    coverage run --source pslab -m pytest
  '';

  pythonImportsCheck = [ "pslab" ];

  meta = with lib; {
    description = "The Python library for the Pocket Science Lab from FOSSASIA";
    homepage = "https://github.com/fossasia/pslab-python";
    license = licenses.gpl3Only;
    maintainers = [ maintainers.viric ];
  };
}
