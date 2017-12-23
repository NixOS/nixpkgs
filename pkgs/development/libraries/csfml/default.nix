{ stdenv, fetchurl, cmake, sfml }:

let
  version = "2.4";
in

stdenv.mkDerivation rec {
  name = "csfml-${version}";
  src = fetchurl {
    url = "https://github.com/SFML/CSFML/archive/${version}.tar.gz";
    sha256 = "4e3d9a03afafbd3a507c39457a7619b68616ec79e870b975e09665e924f9c4c6";
  };
  #preInstall = "echo 'SFML dir:' '${sfml}'";
  buildInputs = [ cmake sfml ];
  cmakeFlags = [ "-DCMAKE_MODULE_PATH=${sfml}/share/SFML/cmake/Modules/"
                 "-DSFML_INSTALL_PKGCONFIG_FILES=yes"
                 ];
  meta = with stdenv.lib; {
    homepage = http://www.sfml-dev.org/;
    description = "Simple and fast multimedia library";
    longDescription = ''
      SFML is a simple, fast, cross-platform and object-oriented multimedia API.
      It provides access to windowing, graphics, audio and network.
      It is written in C++, and has bindings for various languages such as C, .Net, Ruby, Python.
    '';
    license = licenses.zlib;
    maintainers = [ maintainers.astsmtl ];
    platforms = platforms.linux;
  };
}
