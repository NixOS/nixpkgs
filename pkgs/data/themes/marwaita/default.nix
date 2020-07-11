{ stdenv
, fetchFromGitHub
, gdk-pixbuf
, gtk-engine-murrine
, gtk_engines
, librsvg
}:

stdenv.mkDerivation rec {
  pname = "marwaita";
  version = "2020-07-01";

  src = fetchFromGitHub {
    owner = "darkomarko42";
    repo = pname;
    rev = "310a3e596e95005752e14e2b96f55966cbb59d67";
    sha256 = "1r0jqv3hh74965dgc7qwvvhwzf548gb27z69lbpwz060k9di6zwj";
  };

  buildInputs = [
    gdk-pixbuf
    gtk_engines
    librsvg
  ];

  propagatedUserEnvPkgs = [
    gtk-engine-murrine
  ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/themes
    cp -a Marwaita* $out/share/themes
    rm $out/share/themes/*/COPYING
    runHook postInstall
  '';

  meta = with stdenv.lib; {
    description = "GTK theme supporting Budgie, Pantheon, Mate and Xfce4 desktops";
    homepage = "https://www.pling.com/p/1239855/";
    license = licenses.cc0;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
