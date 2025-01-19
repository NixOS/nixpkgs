{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "btrfs";
  version = "14.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-BPKPwT33i8fQYJkUZbnJ8nQNbmKw0Dq6ekb9mr7awEY=";
  };

  # no tests (in v12)
  doCheck = false;
  pythonImportsCheck = [ "btrfs" ];

  meta = {
    description = "Inspect btrfs filesystems";
    homepage = "https://github.com/knorrie/python-btrfs";
    license = lib.licenses.lgpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      evils
      Luflosi
    ];
  };
}
