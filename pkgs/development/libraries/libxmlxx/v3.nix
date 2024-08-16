{ lib, stdenv, fetchurl, pkg-config, libxml2, glibmm, perl, gnome }:

stdenv.mkDerivation rec {
  pname = "libxml++";
  version = "3.0.1";

  src = fetchurl {
    url = "mirror://gnome/sources/libxml++/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "19kik79fmg61nv0by0a5f9wchrcfjwzvih4v2waw01hqflhqvp0r";
  };

  outputs = [ "out" "dev" "doc" "devdoc" ];

  nativeBuildInputs = [ pkg-config perl ];

  buildInputs = [ glibmm ];

  propagatedBuildInputs = [ libxml2 ];

  postFixup = ''
    substituteInPlace $dev/lib/pkgconfig/libxml++-3.0.pc \
      --replace 'docdir=''${datarootdir}' "docdir=$doc/share"
  '';

  passthru = {
    updateScript = gnome.updateScript {
      attrPath = "libxmlxx3";
      packageName = pname;
      versionPolicy = "odd-unstable";
      freeze = true;
    };
  };

  meta = with lib; {
    homepage = "https://libxmlplusplus.sourceforge.net/";
    description = "C++ wrapper for the libxml2 XML parser library, version 3";
    license = licenses.lgpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ loskutov ];
  };
}
