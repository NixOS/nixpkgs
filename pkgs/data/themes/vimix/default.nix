{ lib
, stdenv
, fetchFromGitHub
, gnome-shell
, gtk-engine-murrine
, gtk_engines
, sassc
, gitUpdater
}:

stdenv.mkDerivation rec {
  pname = "vimix-gtk-themes";
  version = "2022-10-30";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = pname;
    rev = version;
    sha256 = "QGKh2Md25VNVqy58w/LBzNnEM+g4gBMUjj0W0IuVZ1U=";
  };

  nativeBuildInputs = [
    gnome-shell  # needed to determine the gnome-shell version
    sassc
  ];

  buildInputs = [
    gtk_engines
  ];

  propagatedUserEnvPkgs = [
    gtk-engine-murrine
  ];

  postPatch = ''
    patchShebangs install.sh
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/themes
    name= HOME="$TMPDIR" ./install.sh --all --dest $out/share/themes
    rm $out/share/themes/*/{AUTHORS,LICENSE}
    runHook postInstall
  '';

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    description = "Flat Material Design theme for GTK based desktop environments";
    homepage = "https://github.com/vinceliuice/vimix-gtk-themes";
    license = licenses.gpl3Only;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
