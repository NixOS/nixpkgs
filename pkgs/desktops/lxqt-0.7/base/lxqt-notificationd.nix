{ stdenv, fetchgit
, cmake
, qt48

# lxqt dependencies
, libqtxdg
, liblxqt
}:

stdenv.mkDerivation rec {
  basename = "lxqt-notificationd";
  version = "0.7.0";
  name = "${basename}-${version}";

  src = fetchgit {
    url = "https://github.com/lxde/${basename}.git";
    rev = "4980c4ab7d0a3cbd67b0a065fab30f8f16a71da1";
    sha256 = "6d914e89f156767911ffa8432e21471491dea94cc185d26331ff4f0de992ca00";
  };

  buildInputs = [ stdenv cmake qt48 libqtxdg liblxqt ];

  meta = {
    homepage = "http://www.lxqt.org";
    description = "Notification daemon and library";
    license = stdenv.lib.licenses.lgpl21;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.ellis ];
  };
}
