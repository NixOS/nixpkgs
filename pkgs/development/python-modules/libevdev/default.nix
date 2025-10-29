{
  lib,
  buildPythonPackage,
  isPy27,
  fetchPypi,
  replaceVars,
  pkgs,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "libevdev";
  version = "0.12";
  format = "setuptools";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-AulSYy7GwknLucZvb6AAEupEiwZgbHfNE5EzvC/kawg=";
  };

  patches = [
    (replaceVars ./fix-paths.patch {
      libevdev = lib.getLib pkgs.libevdev;
    })
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Python wrapper around the libevdev C library";
    homepage = "https://gitlab.freedesktop.org/libevdev/python-libevdev";
    license = licenses.mit;
    maintainers = with maintainers; [ nickhu ];
  };
}
