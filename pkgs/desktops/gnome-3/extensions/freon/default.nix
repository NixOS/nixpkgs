{ stdenv, fetchFromGitHub, glib }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-freon";
  version = "40";

  uuid = "freon@UshakovVasilii_Github.yahoo.com";

  src = fetchFromGitHub {
    owner = "UshakovVasilii";
    repo = "gnome-shell-extension-freon";
    rev = "EGO-${version}";
    sha256 = "0ak6f5dds9kk3kqww681gs3l1mj3vf22icrvb5m257s299rq8yzl";
  };

  nativeBuildInputs = [ glib ];

  buildPhase = ''
    runHook preBuild
    glib-compile-schemas --strict --targetdir=${uuid}/schemas ${uuid}/schemas
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/gnome-shell/extensions
    cp -r ${uuid} $out/share/gnome-shell/extensions
    runHook postInstall
  '';

  meta = with stdenv.lib; {
    description = "GNOME Shell extension for displaying CPU, GPU, disk temperatures, voltage and fan RPM in the top panel";
    license = licenses.gpl2;
    maintainers = with maintainers; [ justinas ];
    homepage = "https://github.com/UshakovVasilii/gnome-shell-extension-freon";
  };
}
