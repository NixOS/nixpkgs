{ stdenv, fetchurl, pkgconfig, glib, libsoup, gobjectIntrospection, gnome3 }:

let
  pname = "rest";
  version = "0.8.1";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "0513aad38e5d3cedd4ae3c551634e3be1b9baaa79775e53b2dba9456f15b01c9";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ glib libsoup gobjectIntrospection];

  configureFlags = [ "--with-ca-certificates=/etc/ssl/certs/ca-certificates.crt" ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "gnome3.${pname}";
    };
  };

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Projects/Librest;
    license = licenses.lgpl21;
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
  };
}
