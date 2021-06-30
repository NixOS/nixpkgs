{ lib, stdenv, fetchFromGitHub, gtk_engines, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  pname = "vimix-gtk-themes";
  version = "2021-04-25";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = pname;
    rev = version;
    sha256 = "0ak763vs27h5z2pgcqpz1g1hypn5gl0p0ylffawc9zdi1wp2mpxb";
  };

  buildInputs = [ gtk_engines ];

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  installPhase = ''
    runHook preInstall
    patchShebangs .
    mkdir -p $out/share/themes
    name= ./install.sh --all --dest $out/share/themes
    rm $out/share/themes/*/{AUTHORS,LICENSE}
    runHook postInstall
  '';

  meta = with lib; {
    description = "Flat Material Design theme for GTK based desktop environments";
    homepage = "https://github.com/vinceliuice/vimix-gtk-themes";
    license = licenses.gpl3Only;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
