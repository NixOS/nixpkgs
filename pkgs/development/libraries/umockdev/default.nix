{ stdenv, fetchFromGitHub, autoreconfHook, umockdev, gobject-introspection
, pkgconfig, glib, systemd, libgudev, vala }:

stdenv.mkDerivation rec {
  name = "umockdev-${version}";
  version = "0.12.1";

  outputs = [ "bin" "out" "dev" "doc" ];

  src = fetchFromGitHub {
    owner  = "martinpitt";
    repo   = "umockdev";
    rev    = version;
    sha256 = "0wnmz4jh04mvqzjnqvxrah969gg4x4v8d6ip61zc7jpbwnqb2fpg";
  };

  # autoreconfHook complains if we try to build the documentation
  postPatch = ''
    echo 'EXTRA_DIST =' > docs/gtk-doc.make
  '';

  buildInputs = [ glib systemd libgudev ];

  nativeBuildInputs = [ autoreconfHook pkgconfig vala gobject-introspection ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Mock hardware devices for creating unit tests";
    license = licenses.lgpl2;
    maintainers = with maintainers; [ ndowens ];
    platforms = with platforms; linux;
  };
}
