{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  pytestCheckHook,
  pythonOlder,
  borgbackup,
  appdirs,
  arrow,
  docopt,
  inform,
  nestedtext,
  parametrize-from-file,
  quantiphy,
  requests,
  shlib,
  voluptuous,
}:

buildPythonPackage rec {
  pname = "emborg";
  version = "1.39";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "KenKundert";
    repo = "emborg";
    rev = "refs/tags/v${version}";
    hash = "sha256-DK98VAYSwN+UKuwwbd2O+gF2PDQPosbXo9D2Zrwe/yU=";
  };

  nativeBuildInputs = [ flit-core ];

  propagatedBuildInputs = [
    appdirs
    arrow
    docopt
    inform
    quantiphy
    requests
  ];

  nativeCheckInputs = [
    nestedtext
    parametrize-from-file
    pytestCheckHook
    shlib
    voluptuous
    borgbackup
  ];

  # this disables testing fuse mounts
  MISSING_DEPENDENCIES = "fuse";

  postPatch = ''
    patchShebangs .
  '';

  pythonImportsCheck = [ "emborg" ];

  meta = with lib; {
    description = "Interactive command line interface to Borg Backup";
    homepage = "https://github.com/KenKundert/emborg";
    changelog = "https://github.com/KenKundert/emborg/releases/tag/v${version}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ jpetrucciani ];
  };
}
