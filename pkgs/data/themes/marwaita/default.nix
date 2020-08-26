{ stdenv
, fetchFromGitHub
, gdk-pixbuf
, gtk-engine-murrine
, gtk_engines
, librsvg
}:

stdenv.mkDerivation rec {
  pname = "marwaita";
  version = "7.4.2";

  src = fetchFromGitHub {
    owner = "darkomarko42";
    repo = pname;
    rev = version;
    sha256 = "0kq7d8nqp8m0kbh2k9s0yybfdkyfkhbkjsv22lplnzh1p84pnlx7";
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
