{ stdenv, fetchurl, lib, file
, pkg-config
, gtkVersion ? "3", gtk2 ? null, gtk3 ? null }:

with lib;

stdenv.mkDerivation rec {
  pname = "libindicator-gtk${gtkVersion}";
  version = "12.10.1";

  src = fetchurl {
    url = "https://launchpad.net/libindicator/${lib.versions.majorMinor version}/${version}/+download/libindicator-${version}.tar.gz";
    sha256 = "b2d2e44c10313d5c9cd60db455d520f80b36dc39562df079a3f29495e8f9447f";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ (if gtkVersion == "2" then gtk2 else gtk3) ];

  postPatch = ''
    substituteInPlace configure \
      --replace 'LIBINDICATOR_LIBS+="$LIBM"' 'LIBINDICATOR_LIBS+=" $LIBM"'
    for f in {build-aux/ltmain.sh,configure,m4/libtool.m4}; do
      substituteInPlace $f\
        --replace /usr/bin/file ${file}/bin/file
    done
  '';

  configureFlags = [
    "CFLAGS=-Wno-error"
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    "--with-gtk=${gtkVersion}"
  ];

  installFlags = [
    "sysconfdir=\${out}/etc"
    "localstatedir=\${TMPDIR}"
  ];

  doCheck = false; # fails 8 out of 8 tests

  meta = {
    description = "A set of symbols and convenience functions for Ayatana indicators";
    homepage = "https://launchpad.net/libindicator";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.msteen ];
  };
}
