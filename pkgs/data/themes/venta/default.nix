{ lib
, stdenv
, fetchFromGitHub
, gdk-pixbuf
, gtk-engine-murrine
, gtk_engines
, librsvg
}:

stdenv.mkDerivation rec {
  pname = "venta";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "darkomarko42";
    repo = pname;
    rev = version;
    sha256 = "14ckkvyarq1xmf48fh47by5h3jnkmksj2n4y6zvx3aw7pfg2jc51";
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
    runHook postInstall
  '';

  meta = with lib; {
    description = "Gtk theme based on windows 10 style";
    homepage = "https://www.pling.com/p/1386774/";
    license = licenses.gpl3Only;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
