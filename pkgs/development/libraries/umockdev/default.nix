{ stdenv, fetchFromGitHub, autoreconfHook, libtool
, pkgconfig, glib, systemd, libgudev, vala }:

stdenv.mkDerivation rec {
  name = "umockdev-${version}";
  version = "0.12";

  src = fetchFromGitHub {
    owner  = "martinpitt";
    repo   = "umockdev";
    rev    = version;
    sha256 = "1j7kkxpqs991w3qdlb779gzv38l1vpnlk3laabi2ndk83j1wl5k2";
  };

  # autoreconfHook complains if we try to build the documentation
  postPatch = ''
    echo 'EXTRA_DIST =' > docs/gtk-doc.make
  '';

  buildInputs = [ glib systemd libgudev ];

  nativeBuildInputs = [ autoreconfHook libtool pkgconfig vala ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Mock hardware devices for creating unit tests";
    license = licenses.lgpl2;
    maintainers = with maintainers; [ ndowens ];
    platforms = with platforms; linux;
  };
}
