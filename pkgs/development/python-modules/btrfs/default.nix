{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "btrfs";
  version = "15";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-FBmRT/FB3+nhb9BHfZVI1L6nM+zXdYjoy3JVzhetoQs=";
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
      Luflosi
    ];
  };
}
