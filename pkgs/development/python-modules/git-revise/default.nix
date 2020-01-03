{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, tox
, pytest
, pylint
, mypy
, black
}:

buildPythonPackage rec {
  pname = "git-revise";
  version = "0.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0l3xhg00106p7ysg4gl9dna2zcrax58mzmm0ajjaxw58jfn8wsf1";
  };

  disabled = pythonOlder "3.6";

  checkInputs = [ tox pytest pylint mypy black ];

  checkPhase = ''
    tox
  '';

  meta = with lib; {
    description = "Efficiently update, split, and rearrange git commits";
    homepage = https://github.com/mystor/git-revise;
    changelog = "https://github.com/mystor/git-revise/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ emily ];
  };
}
