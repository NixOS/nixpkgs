{ stdenv, fetchgit, qjson, kdelibs }:

stdenv.mkDerivation {
  name = "libkvkonatkte-1.0-pre20120103";

  src = fetchgit {
    url = git://anongit.kde.org/libkvkontakte;
    rev = "4024f69cf54625dbe5dc2e2d811a996774a669ff";
    sha256 = "0ryvjfrsws845k9s76715xid48y01h0ynb5wdx6ln8cm5z5wqj61";
  };

  buildInputs = [ qjson kdelibs ];

  meta = {
    homepage = https://projects.kde.org/projects/extragear/libs/libkvkontakte;
    description = "KDE library for interaction with vkontakte.ru social network via its open API";
    maintainers = [ stdenv.lib.maintainers.urkud ];
    inherit (kdelibs.meta) platforms;
  };
}
