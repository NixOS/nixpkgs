{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  pygobject3,
  xvfb-run,
  gobject-introspection,
  gtk3,
  pytest,
  setuptools,
}:

buildPythonPackage rec {
  pname = "liblarch";
  version = "3.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "getting-things-gnome";
    repo = "liblarch";
    rev = "v${version}";
    hash = "sha256-A2qChe2z6rAhjRVX5VoHQitebf/nMATdVZQgtlquuYg=";
  };

  build-system = [
    setuptools
  ];

  nativeCheckInputs = [
    gobject-introspection # for setup hook
    gtk3
    pytest
  ];

  buildInputs = [ gtk3 ];

  propagatedBuildInputs = [ pygobject3 ];

  checkPhase = ''
    runHook preCheck
    ${xvfb-run}/bin/xvfb-run -s '-screen 0 800x600x24' pytest
    runHook postCheck
  '';

  meta = {
    description = "Python library built to easily handle data structure such are lists, trees and acyclic graphs";
    homepage = "https://github.com/getting-things-gnome/liblarch";
    downloadPage = "https://github.com/getting-things-gnome/liblarch/releases";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ oyren ];
    platforms = lib.platforms.linux;
  };
}
