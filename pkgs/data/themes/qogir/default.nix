{ stdenv, fetchFromGitHub, gdk-pixbuf, librsvg, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  pname = "qogir-theme";
  version = "2020-02-26";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = pname;
    rev = version;
    sha256 = "1s14knj0ral5a62ymwbg5k5g94v8cq0acq0kyam8ay0rfi7wycdm";
  };

  buildInputs = [ gdk-pixbuf librsvg ];

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  installPhase = ''
    patchShebangs .
    mkdir -p $out/share/themes
    name= ./install.sh -d $out/share/themes
    mkdir -p $out/share/doc/${pname}
    cp -a src/firefox $out/share/doc/${pname}
    rm $out/share/themes/*/{AUTHORS,COPYING}
  '';

  meta = with stdenv.lib; {
    description = "Flat Design theme for GTK based desktop environments";
    homepage = "https://vinceliuice.github.io/Qogir-theme";
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
