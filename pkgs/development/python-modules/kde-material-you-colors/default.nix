{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,

  dbus-python,
  numpy,
  pillow,
  materialyoucolor,
  python-magic,
  pywal16,
}:

buildPythonPackage (finalAttrs: {
  pname = "kde-material-you-colors";
  version = "2.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "luisbocanegra";
    repo = "kde-material-you-colors";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sN7u3jePevJnTHhQL6eAYKU2AD2QNW7VYuEHLN5RsK8=";
  };

  build-system = [ setuptools ];
  dependencies = [
    dbus-python
    numpy
    pillow
    materialyoucolor
    python-magic
    pywal16
  ];

  pythonImportsCheck = [ "kde_material_you_colors" ];

  doCheck = false; # no unittests, and would require KDE desktop environment

  meta = {
    homepage = "https://store.kde.org/p/2136963";
    description = "Automatic color scheme generator from your wallpaper for KDE Plasma powered by Material You";
    license = lib.licenses.gpl3Only;
    maintainers = [ ];
    mainProgram = "kde-material-you-colors";
  };
})
