{ lib, stdenv, fetchFromGitHub, gnome3, glib }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-dynamic-panel-transparency";
  version = "35";

  src = fetchFromGitHub {
    owner = "ewlsh";
    repo = "dynamic-panel-transparency";
    rev = "0800c0a921bb25f51f6a5ca2e6981b1669a69aec";
    sha256 = "0200mx861mlsi9lf7h108yam02jfqqw55r521chkgmk4fy6z99pq";
  };

  uuid = "dynamic-panel-transparency@rockon999.github.io";

  nativeBuildInputs = [ glib ];

  buildPhase = ''
    runHook preBuild
    glib-compile-schemas --strict --targetdir=${uuid}/schemas/ ${uuid}/schemas
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/gnome-shell/extensions/${uuid}
    cp -r ${uuid} $out/share/gnome-shell/extensions
    runHook postInstall
  '';

  meta = with lib; {
    description = "This extension fades your top panel to nothingness when there are no maximized windows present";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ rhoriguchi ];
    homepage = "https://github.com/ewlsh/dynamic-panel-transparency";
    broken = versionOlder gnome3.gnome-shell.version "3.36";
  };
}
