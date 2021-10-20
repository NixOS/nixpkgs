{ lib, stdenv, fetchFromGitHub, glib, gettext, bash }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-caffeine";
  version = "38";

  src = fetchFromGitHub {
    owner = "eonpatapon";
    repo = "gnome-shell-extension-caffeine";
    rev = "v${version}";
    sha256 = "0dyagnjmk91h96xr98mc177c473bqpxcv86qf6g3kyh3arwa9shs";
  };

  passthru = {
   extensionPortalSlug = "caffeine";
   extensionUuid = "caffeine@patapon.info";
  };

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
    cp -r "caffeine@patapon.info" $out/share/gnome-shell/extensions
    runHook postInstall
  '';

  meta = with lib; {
    description = "Fill the cup to inhibit auto suspend and screensaver";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ eperuffo ];
    homepage = "https://github.com/eonpatapon/gnome-shell-extension-caffeine";
  };
}
