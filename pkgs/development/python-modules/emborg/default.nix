{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  pytestCheckHook,
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
  version = "1.42";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "KenKundert";
    repo = "emborg";
    tag = "v${version}";
    hash = "sha256-/xinm/Jz4JVmm0jioLAhkbBueZCM0ehgt4gsgE7hX6I=";
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

  meta = {
    description = "Interactive command line interface to Borg Backup";
    homepage = "https://github.com/KenKundert/emborg";
    changelog = "https://github.com/KenKundert/emborg/releases/tag/${src.tag}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ jpetrucciani ];
  };
}
