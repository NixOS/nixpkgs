{ stdenv, fetchFromGitHub, glib, gettext, bash, gnome3 }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-caffeine-unstable";
  version = "2020-03-13";

  src = fetchFromGitHub {
    owner = "eonpatapon";
    repo = "gnome-shell-extension-caffeine";
    rev = "f25fa5cd586271f080c2304d0ad1273b55e864f5";
    sha256 = "12a76g1ydw677pjnj00r3vw31k4xybc63ynqzx3s4g0wi6lipng7";
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

  meta = with stdenv.lib; {
    description = "Fill the cup to inhibit auto suspend and screensaver";
    license = licenses.gpl2;
    maintainers = with maintainers; [ eperuffo ];
    homepage = "https://github.com/eonpatapon/gnome-shell-extension-caffeine";
  };
}
