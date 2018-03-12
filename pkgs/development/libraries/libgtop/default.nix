{ stdenv, fetchurl, glib, pkgconfig, perl, gettext, gobjectIntrospection, libintlOrEmpty, gnome3 }:
let
  pname = "libgtop";
  version = "2.38.0";
in
stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "04mnxgzyb26wqk6qij4iw8cxwl82r8pcsna5dg8vz2j3pdi0wv2g";
  };

  propagatedBuildInputs = [ glib ];
  buildInputs = libintlOrEmpty;
  nativeBuildInputs = [ pkgconfig perl gettext gobjectIntrospection ];

  NIX_LDFLAGS = stdenv.lib.optionalString stdenv.isDarwin "-lintl";

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
  };

  meta = with stdenv.lib; {
    description = "A library that reads information about processes and the running system";
    license = licenses.gpl2Plus;
    maintainers = gnome3.maintainers;
    platforms = with platforms; linux ++ darwin;
  };
}
