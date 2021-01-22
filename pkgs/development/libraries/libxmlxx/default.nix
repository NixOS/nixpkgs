{ lib, stdenv, fetchurl, pkg-config, libxml2, glibmm, perl, gnome3 }:

stdenv.mkDerivation rec {
  pname = "libxml++";
  version = "2.40.1";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1sb3akryklvh2v6m6dihdnbpf1lkx441v972q9hlz1sq6bfspm2a";
  };

  outputs = [ "out" "devdoc" ];

  nativeBuildInputs = [ pkg-config perl ];

  propagatedBuildInputs = [ libxml2 glibmm ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
  };

  meta = with lib; {
    homepage = "http://libxmlplusplus.sourceforge.net/";
    description = "C++ wrapper for the libxml2 XML parser library";
    license = licenses.lgpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ phreedom ];
  };
}
