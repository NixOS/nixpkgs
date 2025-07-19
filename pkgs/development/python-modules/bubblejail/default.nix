{
  lib,
  python3,
  fetchFromGitHub,
  xdg-dbus-proxy,
  bubblewrap,
  libseccomp,
  libnotify,
  desktop-file-utils,
  scdoc,
}:
python3.pkgs.buildPythonPackage rec {
  pname = "bubblejail";
  version = "0.9.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "igo95862";
    repo = "bubblejail";
    tag = version;
    hash = "sha256-zQuNS26FgQpjVmjzNjw/tHP/H2rs53jqNlYZR3kqfzU=";
  };

  build-system = [python3.pkgs.meson-python];

  patches = [
    ./scan-store.patch
    ./env-python.patch
    ./meson-options.patch
  ];

  dependencies = with python3.pkgs; [
    pyxdg
    tomli-w
    pyqt6
    lxns
  ];

  buildInputs = [
    xdg-dbus-proxy
    bubblewrap
    libseccomp
    libnotify
    desktop-file-utils
  ];

  nativeBuildInputs = [
    # scdoc
    python3.pkgs.jinja2
  ];

  pythonImportsCheck = [
    "bubblejail"
  ];

  meta = {
    description = "Bubblewrap based sandboxing for desktop applications";
    homepage = "https://github.com/igo95862/bubblejail/";
    changelog = "https://github.com/igo95862/bubblejail/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [justdeeevin];
    mainProgram = "bubblejail";
  };
}
