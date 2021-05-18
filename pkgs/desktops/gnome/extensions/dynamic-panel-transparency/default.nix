{ lib, stdenv, fetchFromGitHub, gnome, glib }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-dynamic-panel-transparency";
  version = "unstable-2021-03-04";

  src = fetchFromGitHub {
    owner = "ewlsh";
    repo = "dynamic-panel-transparency";
    rev = "f9e720e98e40c7a2d87928d09a7313c9ef2e832c";
    sha256 = "0njykxjiwlcmk0q8bsgqaznsryaw43fspfs6rzsjjz5p0xaq04nw";
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
    broken = versionOlder gnome.gnome-shell.version "3.36";
  };
}
