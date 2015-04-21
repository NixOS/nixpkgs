{ stdenv, fetchgit, curl, libxml2 }:

stdenv.mkDerivation {
  name = "libs3-2015-01-09";

  src = fetchgit {
    url = "git://github.com/bji/libs3.git";
    rev = "4d21fdc0857b88c964649b321057d7105d1e4da3";
    sha256 = "058sixppk078mdn9ii3swg87nbpgl86llz9mdhj5km5m53a7dnjw";
  };

  buildInputs = [ curl libxml2 ];

  DESTDIR = "\${out}";

  meta = with stdenv.lib; {
    homepage = https://github.com/bji/libs3;
    description = "a library for interfacing with amazon s3";
    licenses = licenses.gpl3;
    platforms = platforms.unix;
  };
}
