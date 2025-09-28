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
}:

buildPythonPackage rec {
  pname = "ponytail";
  version = "0.0.12-dev";
  pyproject = true;

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "ofourdan";
    repo = "gnome-ponytail-daemon";
    rev = "9dd3bda1816de216219232b8f6baec9f2d423ec6";
    hash = "sha256-0DvrYN/UP7SFNcVeh+3nuBUumiizFS+TAjFApu1oIIM=";
  };

  patchPhase = ''
    echo '
[project]
name = "ponytail"
version = "0.0.12-dev"
    ' >> pyproject.toml
    cat pyproject.toml
  '';

  build-system = [
    meson
    ninja
    setuptools
  ];

  propagatedBuildInputs = [
  ];

  meta = with lib; {
    description = "Sort of a bridge for dogtail for GNOME on Wayland";
    mainProgram = "gnome-ponytail-daemo";
    homepage = "https://gitlab.gnome.org/ofourdan/gnome-ponytail-daemon";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ ];
  };
}
