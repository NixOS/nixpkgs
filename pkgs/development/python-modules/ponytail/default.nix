{
  lib,
  buildPythonPackage,
  python,
  fetchPypi,
  meson,
  ninja,
  fetchFromGitLab,
  pkg-config,
  setuptools,
  dbus,
  at-spi2-core,
  gtk3,
  pygobject3,
  pyatspi,
  pycairo,
  dbus-python,
}:

buildPythonPackage rec {
  pname = "ponytail";
  version = "0.0.12-dev";
  pyproject = true;

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "ofourdan";
    repo = "gnome-ponytail-daemon";
    rev = "9dd3bda1816de216219232b8f6baec9f2d423ec6";
    hash = "sha256-0DvrYN/UP7SFNcVeh+3nuBUumiizFS+TAjFApu1oIIM=";
  };
  sourceRoot = "${src.name}/ponytail";

  patchPhase = ''
    echo '
[project]
name = "ponytail"
version = "0.0.12-dev"
dependencies = [
]

[build-system]
requires = ["setuptools>=42", "wheel"]
build-backend = "setuptools.build_meta"

    ' >> pyproject.toml
    cat pyproject.toml
  '';

  build-system = [
    meson
    ninja
    setuptools
  ];

  nativeBuildInputs = [
    dbus
  ];

  propagatedBuildInputs = [
    at-spi2-core
    gtk3
    pygobject3
    pyatspi
    pycairo
    dbus-python
  ];

  meta = with lib; {
    description = "Sort of a bridge for dogtail for GNOME on Wayland";
    mainProgram = "gnome-ponytail-daemo";
    homepage = "https://gitlab.gnome.org/ofourdan/gnome-ponytail-daemon";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ ];
  };
}
