{ stdenv, autoreconfHook, pkgconfig, fetchFromGitHub, dbus, dleyna-core, glib }:

stdenv.mkDerivation rec {
  pname = "dleyna-connector-dbus";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "01org";
    repo = pname;
    rev = version;
    sha256 = "0vziq5gwjm79yl2swch2mz6ias20nvfddf5cqgk9zbg25cb9m117";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ dbus dleyna-core glib ];

  meta = with stdenv.lib; {
    description = "A D-Bus API for the dLeyna services";
    homepage = "https://01.org/dleyna";
    maintainers = [ maintainers.jtojnar ];
    platforms = platforms.linux;
    license = licenses.lgpl21;
  };
}
