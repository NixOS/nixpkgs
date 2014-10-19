{ stdenv, fetchgit, pkgconfig
, cmake
, qt48

, libqtxdg
, liblxqt
, lxqt-globalkeys
}:

stdenv.mkDerivation rec {
  basename = "lxqt-runner";
  version = "0.7.0";
  name = "${basename}-${version}";

  src = fetchgit {
    url = "https://github.com/lxde/${basename}.git";
    rev = "1f323d9b53868218765620646a6b7903791867c5";
    sha256 = "190b0ab183a95dbcc126a53997c2e1028f5752d720006ad34ec9b698eb4c68cb";
  };

  buildInputs = [
    stdenv pkgconfig
    cmake qt48
    libqtxdg liblxqt lxqt-globalkeys
  ];

  meta = {
    homepage = "http://www.lxqt.org";
    description = "Launch applications quickly by typing commands";
    license = stdenv.lib.licenses.lgpl21;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.ellis ];
  };
}
