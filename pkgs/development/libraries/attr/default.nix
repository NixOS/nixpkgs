{ stdenv, fetchurl, gettext, hostPlatform }:

stdenv.mkDerivation rec {
  name = "attr-2.4.47";

  src = fetchurl {
    url = "mirror://savannah/attr/${name}.src.tar.gz";
    sha256 = "0nd8y0m6awc9ahv0ciiwf8gy54c8d3j51pw9xg7f7cn579jjyxr5";
  };

  outputs = [ "bin" "dev" "out" "man" "doc" ];

  nativeBuildInputs = [ gettext ];

  configureFlags = [ "MAKE=make" "MSGFMT=msgfmt" "MSGMERGE=msgmerge" "XGETTEXT=xgettext" "ECHO=echo" "SED=sed" "AWK=gawk" ];

  installTargets = [ "install" "install-lib" "install-dev" ];

  patches = if (hostPlatform.libc == "musl") then [ ./fix-headers-musl.patch ] else null;

  postPatch = ''
    for script in install-sh include/install-sh; do
      patchShebangs $script
    done
  '';

  meta = with stdenv.lib; {
    homepage = "http://savannah.nongnu.org/projects/attr/";
    description = "Library and tools for manipulating extended attributes";
    platforms = platforms.linux;
    license = licenses.gpl2Plus;
  };
}
