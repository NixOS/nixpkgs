{ stdenv
, fetchFromGitHub
, buildPythonPackage
, python
, pygobject3
, xvfb_run
, gobject-introspection
, gtk3
, pythonOlder
}:

buildPythonPackage rec {
  version = "3.0.1";
  pname = "liblarch";
  disabled = pythonOlder "3.5.0";

  src = fetchFromGitHub {
    owner = "getting-things-gnome";
    repo = "liblarch";
    rev = "v${version}";
    sha256 = "0xv2mfvyzipbny3iz8vll77wsqxfwh28xj6bj1ff0l452waph45m";
  };

  checkInputs = [
    gobject-introspection # for setup hook
    gtk3
  ];

  propagatedBuildInputs = [
    pygobject3
  ];

  checkPhase = ''
    runHook preCheck
    ${xvfb_run}/bin/xvfb-run -s '-screen 0 800x600x24' \
      ${python.interpreter} nix_run_setup test
    runHook postCheck
  '';

  meta = with stdenv.lib; {
    description = "A python library built to easily handle data structure such are lists, trees and acyclic graphs";
    homepage = "https://github.com/getting-things-gnome/liblarch";
    downloadPage = "https://github.com/getting-things-gnome/liblarch/releases";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ oyren ];
    platforms = platforms.linux;
  };
}
