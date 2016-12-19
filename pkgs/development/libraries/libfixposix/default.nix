{ stdenv, fetchurl, fetchgit, autoreconfHook, libtool }:

stdenv.mkDerivation rec {
  name="libfixposix-${version}";
  version="git-${src.rev}";

  src = fetchgit {
    url = "https://github.com/sionescu/libfixposix";
    rev = "30b75609d858588ea00b427015940351896867e9";
    sha256 = "17spjz9vbgqllzlkws2abvqi0a71smhi4vgq3913aw0kq206mfxz";
  };

  buildInputs = [ autoreconfHook libtool ];

  meta = with stdenv.lib; {
    description = "A set of workarounds for places in POSIX that get implemented differently";
    maintainers = with maintainers;
    [
      raskin
    ];
    platforms = platforms.linux;
  };
  passthru = {
    updateInfo = {
      downloadPage = "http://gitorious.org/libfixposix/libfixposix";
    };
  };
}
