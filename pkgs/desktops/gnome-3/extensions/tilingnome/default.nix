{ stdenv, lib, fetchFromGitHub, glib, gnome3 }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-tilingnome-unstable";
  version = "unstable-2019-09-19";

  src = fetchFromGitHub {
    owner = "rliang";
    repo = "gnome-shell-extension-tilingnome";
    rev = "f401c20c9721d85e6b3e30d1e822a200db370407";
    sha256 = "1hq9g9bxqpzqrdj9zm0irld8r6q4w1m4b00jya7wsny8rzb1s0y2";
  };

  nativeBuildInputs = [ glib ];

  buildPhase = ''
    runHook preBuild
    glib-compile-schemas .
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/gnome-shell/extensions/${uuid}
    cp -r * $out/share/gnome-shell/extensions/${uuid}/
    runHook postInstall
  '';

  uuid = "tilingnome@rliang.github.com";

  meta = with stdenv.lib; {
    description = "Tiling window management for GNOME Shell";
    license = licenses.gpl2;
    maintainers = with maintainers; [ benley ];
    homepage = "https://github.com/rliang/gnome-shell-extension-tilingnome";
    platforms = gnome3.gnome-shell.meta.platforms;
  };
}
