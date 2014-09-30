{ stdenv, fetchgit, pkgconfig
, cmake
, qt48

, libconfig
}:

stdenv.mkDerivation rec {
  basename = "compton-conf";
  version = "0.1.0";
  name = "${basename}-${version}";

  src = fetchgit {
    url = "https://github.com/lxde/${basename}.git";
    rev = "3e095cd927a8e2fa6b4b7fb1fab1efbb7a051415";
    sha256 = "a725a4f92e05c374ccbc0e5fe78926fbcb4179a62272111946d6278bf354a6c8";
  };

  buildInputs = [
    stdenv pkgconfig
    cmake qt48
    libconfig
  ];

  meta = {
    homepage = "http://www.lxqt.org";
    description = "X composite manager configuration (for compton)";
    license = stdenv.lib.licenses.lgpl21;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.ellis ];
  };
}
