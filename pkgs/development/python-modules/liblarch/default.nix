{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  python,
  pygobject3,
  xvfb-run,
  gobject-introspection,
  gtk3,
  pythonOlder,
}:

buildPythonPackage rec {
  version = "3.2.0";
  format = "setuptools";
  pname = "liblarch";
  disabled = pythonOlder "3.5.0";

  src = fetchFromGitHub {
    owner = "getting-things-gnome";
    repo = "liblarch";
    rev = "v${version}";
    hash = "sha256-A2qChe2z6rAhjRVX5VoHQitebf/nMATdVZQgtlquuYg=";
  };

  nativeCheckInputs = [
    gobject-introspection # for setup hook
    gtk3
  ];

  buildInputs = [ gtk3 ];

  propagatedBuildInputs = [ pygobject3 ];

  checkPhase = ''
    runHook preCheck
    ${xvfb-run}/bin/xvfb-run -s '-screen 0 800x600x24' \
      ${python.interpreter} nix_run_setup test
    runHook postCheck
  '';

  meta = with lib; {
    description = "A python library built to easily handle data structure such are lists, trees and acyclic graphs";
    homepage = "https://github.com/getting-things-gnome/liblarch";
    downloadPage = "https://github.com/getting-things-gnome/liblarch/releases";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ oyren ];
    platforms = platforms.linux;
  };
}
