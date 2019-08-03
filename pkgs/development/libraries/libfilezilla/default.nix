{ stdenv
, fetchurl

, gettext
, gnutls
, nettle
, pkgconfig
}:

stdenv.mkDerivation rec {
  pname = "libfilezilla";
  version = "0.17.1";

  src = fetchurl {
    url = "https://download.filezilla-project.org/${pname}/${pname}-${version}.tar.bz2";
    sha256 = "1cnkcl9vif5lz1yx813qrphlpc6gvmzxdmkbd17kh5jqiqdi9vyk";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ gettext gnutls nettle ];

  meta = with stdenv.lib; {
    homepage = "https://lib.filezilla-project.org/";
    description = "A modern C++ library, offering some basic functionality to build high-performing, platform-independent programs";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ pSub ];
    platforms = platforms.linux;
  };
}
