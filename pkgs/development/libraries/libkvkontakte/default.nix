{ stdenv, fetchgit, automoc4, cmake, pkgconfig, qjson, kdelibs }:

stdenv.mkDerivation {
  name = "libkvkontakte-1.0-pre20120103";

  src = fetchgit {
    url = git://anongit.kde.org/libkvkontakte;
    rev = "4024f69cf54625dbe5dc2e2d811a996774a669ff";
    sha256 = "1ly95bc72a4zjqhr03liciqpi2hp8x4gqzm4gzr8alfysv2jvxbb";
  };

  nativeBuildInputs = [ automoc4 cmake pkgconfig ];
  buildInputs = [ qjson kdelibs ];

  meta = {
    homepage = https://projects.kde.org/projects/extragear/libs/libkvkontakte;
    description = "KDE library for interaction with vkontakte.ru social network via its open API";
    maintainers = [ stdenv.lib.maintainers.urkud ];
    inherit (kdelibs.meta) platforms;
  };
}
