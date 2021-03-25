{ lib, stdenv, fetchFromGitHub, glib, gettext, bash, gnome3 }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-caffeine";
  version = "37";

  src = fetchFromGitHub {
    owner = "eonpatapon";
    repo = "gnome-shell-extension-caffeine";
    rev = "v${version}";
    sha256 = "1mpa0fbpmv3pblb20dxj8iykn4ayvx89qffpcs67bzlq597zsbkb";
  };

  uuid = "caffeine@patapon.info";

  nativeBuildInputs = [
    glib gettext
  ];

  buildPhase = ''
    runHook preBuild
    ${bash}/bin/bash ./update-locale.sh
    glib-compile-schemas --strict --targetdir=caffeine@patapon.info/schemas/ caffeine@patapon.info/schemas
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/gnome-shell/extensions
    cp -r ${uuid} $out/share/gnome-shell/extensions
    runHook postInstall
  '';

  meta = with lib; {
    description = "Fill the cup to inhibit auto suspend and screensaver";
    license = licenses.gpl2;
    maintainers = with maintainers; [ eperuffo ];
    homepage = "https://github.com/eonpatapon/gnome-shell-extension-caffeine";
  };
}
