{
  lib,
  python3Packages,
  fetchFromGitHub,
  borgbackup,
}:

python3Packages.buildPythonPackage rec {
  pname = "emborg";
  version = "1.42";
  format = "pyproject";

  disabled = python3Packages.pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "KenKundert";
    repo = "emborg";
    tag = "v${version}";
    hash = "sha256-/xinm/Jz4JVmm0jioLAhkbBueZCM0ehgt4gsgE7hX6I=";
  };

  nativeBuildInputs = with python3Packages; [ flit-core ];

  propagatedBuildInputs = with python3Packages; [
    appdirs
    arrow
    docopt
    inform
    quantiphy
    requests
  ];

  nativeCheckInputs =
    (with python3Packages; [
      nestedtext
      parametrize-from-file
      pytestCheckHook
      shlib
      voluptuous
    ])
    ++ [
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
    changelog = "https://github.com/KenKundert/emborg/releases/tag/${src.tag}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ jpetrucciani ];
  };
}
