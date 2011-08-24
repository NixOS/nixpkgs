{stdenv, fetchsvn, fetchsvnrevision, zlib, cmake
, repository ? "svn://anonsvn.kde.org/home/kde/trunk/kdesupport/taglib"
, rev ? fetchsvnrevision repository
, src ? fetchsvn {
    url = repository;
    rev = rev;
  }
}:

stdenv.mkDerivation {
  name = "taglib-live";

  inherit src;

  cmakeFlags = [ "-DWITH-ASF=ON" "-DWITH-MP4=ON" ];

  buildInputs = [ zlib cmake ];

  meta = {
    homepage = http://developer.kde.org/~wheeler/taglib.html;
    description = "A library for reading and editing the meta-data of several popular audio formats";
  };
}
