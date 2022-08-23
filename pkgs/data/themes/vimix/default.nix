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
  version = "2022-04-24";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = pname;
    rev = version;
    sha256 = "0q0ahm060qvr7r9j3x9lxidjnwf032c2g1pcqw9mz93iy7vfn358";
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

  passthru.updateScript = gitUpdater {inherit pname version; };

  meta = with lib; {
    description = "Flat Material Design theme for GTK based desktop environments";
    homepage = "https://github.com/vinceliuice/vimix-gtk-themes";
    license = licenses.gpl3Only;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
