{ stdenv, fetchFromGitHub, cmake, qt5 }:

stdenv.mkDerivation rec {
  name = "libsysstat-${version}";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "lxde";
    repo = "libsysstat";
    rev = version;
    sha256 = "1swpnz37daj3njkbqddmhaiipfl335c3g675y9afhabg7l4anf1n";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ qt5.qtbase ];

  meta = with stdenv.lib; {
    description = "Library used to query system info and statistics";
    homepage = https://github.com/lxde/libsysstat;
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ romildo ];
    platforms = with platforms; unix;
  };
}
