{ stdenv, fetchFromGitHub, autoreconfHook, gtk3, moka-icon-theme }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "faba-mono-icons";
  version = "2016-04-30";

  src = fetchFromGitHub {
    owner = "snwh";
    repo = pname;
    rev = "2006c5281eb988c799068734f289a85443800cda";
    sha256 = "0nisfl92y6hrbakp9qxi0ygayl6avkzrhwirg6854bwqjy2dvjv9";
  };

  nativeBuildInputs = [ autoreconfHook gtk3 moka-icon-theme ];

  postFixup = ''
    for theme in $out/share/icons/*; do
      gtk-update-icon-cache $theme
    done
  '';

  meta = with stdenv.lib; {
    description = "The full set of Faba monochrome panel icons";
    homepage = https://snwh.org/moka;
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ romildo ];
  };
}
