{ stdenv
, fetchFromGitHub
, pkgconfig
, gtk3
, gobject-introspection
}:

stdenv.mkDerivation rec {
  pname = "gtk3-nocsd";
  version = "3.0.1";

  src = fetchFromGitHub {
    owner = "ZaWertun";
    repo = pname;
    rev = "v${version}";
    sha256 = "035rrn9jq9bdfkmmj6xl4q8paqx7xf3hxsw6gslgk86sh7x56lvi";
  };

  buildInputs = [
    gtk3
    gobject-introspection
  ];

  nativeBuildInputs = [
    pkgconfig
  ];

  makeFlags = [
    "prefix=${placeholder "out"}"
  ];

  meta = with stdenv.lib; {
    description = "A hack to disable gtk+ 3 client side decoration";
    homepage = https://github.com/PCMan/gtk3-nocsd;
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ peanutbutter144 ];
    platforms = platforms.linux;
  };
}
