{ lib, stdenv, fetchurl, fetchFromGitHub
, autoreconfHook
, glib
, db
, pkg-config
}:

let
  modelData = fetchurl {
    url    = "mirror://sourceforge/libpinyin/models/model17.text.tar.gz";
    sha256 = "1kb2nswpsqlk2qm5jr7vqcp97f2dx7nvpk24lxjs1g12n252f5z0";
  };
in
stdenv.mkDerivation rec {
  pname = "libpinyin";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner  = "libpinyin";
    repo   = "libpinyin";
    rev    = version;
    sha256 = "14fkpp16s5k0pbw5wwd24pqr0qbdjgbl90n9aqwx72m03n7an40l";
  };

  postUnpack = ''
    tar -xzf ${modelData} -C $sourceRoot/data
  '';

  nativeBuildInputs = [ autoreconfHook glib db pkg-config ];

  meta = with lib; {
    description = "Library for intelligent sentence-based Chinese pinyin input method";
    homepage    = "https://sourceforge.net/projects/libpinyin";
    license     = licenses.gpl2;
    maintainers = with maintainers; [ ericsagnes ];
    platforms   = platforms.linux;
  };
}
