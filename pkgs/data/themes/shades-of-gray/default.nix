{ stdenv, fetchFromGitHub, gtk_engines, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  pname = "shades-of-gray-theme";
  version = "1.1.8";

  src = fetchFromGitHub {
    owner = "WernerFP";
    repo = pname;
    rev = version;
    sha256 = "08i2pkq7ygf9fs9cdrw4khrb8m1w2hvgmz064g36fh35r02sms3w";
  };

  buildInputs = [ gtk_engines ];

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  installPhase = ''
    mkdir -p $out/share/themes
    cp -a Shades-of-gray* $out/share/themes/
  '';

  meta = with stdenv.lib; {
    description = "A flat dark GTK-theme with ergonomic contrasts";
    homepage = https://github.com/WernerFP/Shades-of-gray-theme;
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
