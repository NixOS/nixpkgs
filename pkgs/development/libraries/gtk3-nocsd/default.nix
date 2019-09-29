{ stdenv
, fetchFromGitHub
, pkgconfig
, gtk3
, gobject-introspection
}:

stdenv.mkDerivation rec {
  pname = "gtk3-nocsd";
  version = "3";

  src = fetchFromGitHub {
    owner = "PCMan";
    repo = "gtk3-nocsd";
    rev = "v${version}";
    sha256 = "1x3bk03qilnvbrg7xgw26his5w21lwsbvy4ll23inqfyh4rszllb";
  };

  nativeBuildInputs = [
    pkgconfig
    gtk3
    gobject-introspection
  ];

  makeFlags = [ "prefix=$(out)" ];

  meta = with stdenv.lib; {
    description = "A hack to disable gtk+ 3 client side decoration";
    homepage = https://github.com/PCMan/gtk3-nocsd;
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ peanutbutter144 ];
    platforms = platforms.linux;
  };
}
