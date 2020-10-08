{ stdenv
, fetchFromGitHub
, gdk-pixbuf
, gtk-engine-murrine
, gtk_engines
, librsvg
}:

stdenv.mkDerivation rec {
  pname = "venta";
  version = "2020-08-20";

  src = fetchFromGitHub {
    owner = "darkomarko42";
    repo = pname;
    rev = "f9b7ea560def5c9d25a14015d265ba559d3501ca";
    sha256 = "13rdavspz1q3zk2h04jpd77hxdcifg42kd71qq13ryg4b5yzqqgb";
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
    cp -a Venta* $out/share/themes
    rm $out/share/themes/*/COPYING
    runHook postInstall
  '';

  meta = with stdenv.lib; {
    description = "Gtk theme based on windows 10 style";
    homepage = "https://www.pling.com/p/1386774/";
    license = licenses.gpl3Only;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
