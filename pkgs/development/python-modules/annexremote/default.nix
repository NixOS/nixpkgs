{ lib
, isPy3k
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, nose
, pythonOlder
}:

buildPythonPackage rec {
  pname = "annexremote";
  version = "1.6.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Lykos153";
    repo = "AnnexRemote";
    rev = "v${version}";
    sha256 = "08myswj1vqkl4s1glykq6xn76a070nv5mxj0z8ibl6axz89bvypi";
  };

  checkInputs = [
    nose
  ];

  checkPhase = ''
    nosetests -v -e "^TestExport_MissingName" -e "^TestRemoveexportdirectory"
  '';

  pythonImportsCheck = [
    "annexremote"
  ];

  meta = with lib; {
    description = "Helper module to easily develop git-annex remotes";
    homepage = "https://github.com/Lykos153/AnnexRemote";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ montag451 ];
  };
}
