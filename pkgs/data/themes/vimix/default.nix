{ lib
, stdenv
, fetchFromGitHub
, gnome-shell
, gtk-engine-murrine
, gtk_engines
}:

stdenv.mkDerivation rec {
  pname = "vimix-gtk-themes";
  version = "2021-08-17";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = pname;
    rev = version;
    sha256 = "1pn737w99j4ij8qkgw0rrzhbcqzni73z5wnkfqgqqbhj38rafbpv";
  };

  nativeBuildInputs = [
    gnome-shell  # needed to determine the gnome-shell version
  ];

  buildInputs = [
    gtk_engines
  ];

  propagatedUserEnvPkgs = [
    gtk-engine-murrine
  ];

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
