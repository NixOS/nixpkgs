{ stdenv
, fetchFromGitHub
, gdk-pixbuf
, gtk-engine-murrine
, gtk_engines
, librsvg
}:

stdenv.mkDerivation rec {
  pname = "marwaita-pop_os";
  version = "0.9";

  src = fetchFromGitHub {
    owner = "darkomarko42";
    repo = pname;
    rev = version;
    sha256 = "1fpzsch9rpq7dmg01ny7jc2vd6dks0fqxxp2rb9jcs0vx5d2fdc6";
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
    runHook postInstall
  '';

  meta = with stdenv.lib; {
    description = "Marwaita GTK theme with Pop_os Linux style";
    homepage = "https://www.pling.com/p/1377894/";
    license = licenses.gpl3Only;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
