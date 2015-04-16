{ stdenv, fetchgit
, cmake
, qt54
}:

stdenv.mkDerivation rec {
  basename = "libsysstat";
  version = "0.3.0";
  name = "${basename}-${version}";

  src = fetchgit {
    url = "https://github.com/lxde/${basename}.git";
    rev = "70f70eb97e5b144a63468ea78b6c436bf43cf571";
    sha256 = "25fb7a51106e3753c24c7dffa7ed6a226385936b76136da928e4cc518cdd7389";
  };

  buildInputs = [ stdenv cmake qt54.base qt54.tools ];

  meta = {
    homepage = "http://www.lxqt.org";
    description = "Library used to query system statistics (net status, system resource usage, ...etc)";
    license = stdenv.lib.licenses.lgpl21;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.ellis ];
  };
}
