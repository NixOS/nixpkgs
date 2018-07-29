{ stdenv, fetchurl, json-glib, meson, ninja, pkgconfig, gettext
, gobjectIntrospection, vala, fixDarwinDylibNames, gnome3
}:

let
  pname = "jsonrpc-glib";
  version = "3.28.1";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "0avff2ldjvwrb8rnzlgslagdjf6x7bmdx69rsq20k6f38icw4ang";
  };

  propagatedBuildInputs = [ json-glib ];
  nativeBuildInputs = [ meson ninja pkgconfig gettext gobjectIntrospection vala ];
  buildInputs = stdenv.lib.optional stdenv.isDarwin fixDarwinDylibNames;

  outputs = [ "out" "dev" ];

  # tests fail nondeterministically
  doCheck = false;

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
  };

  meta = with stdenv.lib; {
    description = "A library to communicate using the JSON-RPC 2.0 specification";
    homepage = https://gitlab.gnome.org/GNOME/jsonrpc-glib;
    license = licenses.lgpl2;
    platforms = with platforms; unix;
  };
}
