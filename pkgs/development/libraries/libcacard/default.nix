{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  glib,
  nss,
}:

stdenv.mkDerivation rec {
  pname = "libcacard";
  version = "2.8.1";

  src = fetchurl {
    url = "https://www.spice-space.org/download/libcacard/${pname}-${version}.tar.xz";
    sha256 = "sha256-+79N6Mt9tb3/XstnL/Db5pOfufNEuQDVG6YpUymjMuc=";
  };

  postPatch = lib.optionalString stdenv.isDarwin ''
    sed -i '/--version-script/d' Makefile.in
    sed -i 's/^vflag = .*$/vflag = ""/' meson.build
  '';

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    glib
    nss
  ];

  meta = with lib; {
    description = "Smart card emulation library";
    homepage = "https://gitlab.freedesktop.org/spice/libcacard";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ yana ];
    platforms = platforms.unix;
  };
}
