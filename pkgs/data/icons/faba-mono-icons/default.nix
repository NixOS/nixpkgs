{ stdenv, fetchFromGitHub, autoreconfHook, moka-icon-theme  }:

stdenv.mkDerivation rec {
  name = "${package-name}-${version}";
  package-name = "faba-mono-icons";
  version = "2016-04-30";

  src = fetchFromGitHub {
    owner = "moka-project";
    repo = package-name;
    rev = "2006c5281eb988c799068734f289a85443800cda";
    sha256 = "0nisfl92y6hrbakp9qxi0ygayl6avkzrhwirg6854bwqjy2dvjv9";
  };

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [ moka-icon-theme ];

  meta = with stdenv.lib; {
    description = "The full set of Faba monochrome panel icons";
    homepage = https://snwh.org/moka;
    license = with licenses; [ gpl3 ];
    platforms = platforms.all;
    maintainers = with maintainers; [ romildo ];
  };
}
