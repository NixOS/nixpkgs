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

<<<<<<< HEAD
  meta = {
    description = "Inspect btrfs filesystems";
    homepage = "https://github.com/knorrie/python-btrfs";
    license = lib.licenses.lgpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
=======
  meta = with lib; {
    description = "Inspect btrfs filesystems";
    homepage = "https://github.com/knorrie/python-btrfs";
    license = licenses.lgpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      Luflosi
    ];
  };
}
