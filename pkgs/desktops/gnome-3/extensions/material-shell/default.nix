{ stdenv, lib, fetchFromGitHub, gnome3 }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-material-shell";
  version = "8";

  src = fetchFromGitHub {
    owner = "material-shell";
    repo = "material-shell";
    rev = version;
    sha256 = "08zc6xl2b7k7l5l6afr40ii3gnxxbysan3cqv2s9g614rbsmc62r";
  };

  # This package has a Makefile, but it's used for building a zip for
  # publication to extensions.gnome.org. Disable the build phase so
  # installing doesn't build an unnecessary release.
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/gnome-shell/extensions/${uuid}
    cp -r * $out/share/gnome-shell/extensions/${uuid}/
    runHook postInstall
  '';

  uuid = "material-shell@papyelgringo";

  meta = with stdenv.lib; {
    description = "A modern desktop interface for Linux";
    license = licenses.mit;
    maintainers = with maintainers; [ benley ];
    homepage = "https://github.com/material-shell/material-shell";
    platforms = gnome3.gnome-shell.meta.platforms;
  };
}
