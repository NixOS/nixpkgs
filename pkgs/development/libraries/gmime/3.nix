{ lib, stdenv, fetchurl, pkg-config, glib, zlib, gnupg, gpgme, libidn2, libunistring, gobject-introspection
, vala }:

stdenv.mkDerivation rec {
  version = "3.2.12";
  pname = "gmime";

  src = fetchurl { # https://github.com/jstedfast/gmime/releases
    url = "https://github.com/jstedfast/gmime/releases/download/${version}/gmime-${version}.tar.xz";
    sha256 = "sha256-OPm3aBgjQsSExBIobbjVgRaX/4FiQ3wFea3w0G4icFs=";
  };

  outputs = [ "out" "dev" ];

  buildInputs = [ vala gobject-introspection zlib gpgme libidn2 libunistring ];
  nativeBuildInputs = [ pkg-config ];
  propagatedBuildInputs = [ glib ];
  configureFlags = [
    "--enable-introspection=yes"
    "--enable-vala=yes"
  ];

  postPatch = ''
    substituteInPlace tests/testsuite.c \
      --replace /bin/rm rm
  '';

  nativeCheckInputs = [ gnupg ];

  doCheck = true;

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://github.com/jstedfast/gmime/";
    description = "A C/C++ library for creating, editing and parsing MIME messages and structures";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ ];
    platforms = platforms.unix;
  };
}
