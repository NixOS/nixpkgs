{ lib
, buildPythonPackage
, fetchPypi
, pythonAtLeast
, tox
, pytest
, pylint
, mypy
, black
}:

buildPythonPackage rec {
  pname = "git-revise";
  version = "0.4.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1mq1fh8m6jxl052d811cgpl378hiq20a8zrhdjn0i3dqmxrcb8vs";
  };

  disabled = !(pythonAtLeast "3.6");

  checkInputs = [ tox pytest pylint mypy black ];

  checkPhase = ''
    tox
  '';

  meta = with lib; {
    description = "Efficiently update, split, and rearrange git commits";
    homepage = https://github.com/mystor/git-revise;
    license = licenses.mit;
    maintainers = with maintainers; [ emily ];
  };
}
