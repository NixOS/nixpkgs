{ stdenv, fetchgit
, cmake
, qt48
}:

stdenv.mkDerivation rec {
  basename = "libsysstat";
  version = "0.1.0";
  name = "${basename}-${version}";

  src = fetchgit {
    url = "https://github.com/lxde/${basename}.git";
    rev = "574dee2d9c6b6f13caa14089bbbe13a9bfa6555e";
    sha256 = "df2cfd4de1661b9dc0c76475609ff1e07d84eb412711ab08e5c1a8e5db7669b4";
  };

  buildInputs = [ stdenv cmake qt48 ];

  meta = {
    homepage = "http://www.lxqt.org";
    description = "Library used to query system statistics (net status, system resource usage, ...etc)";
    license = stdenv.lib.licenses.lgpl21;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.ellis ];
  };
}
