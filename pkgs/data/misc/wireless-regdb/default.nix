{ stdenv, fetchgit }:

stdenv.mkDerivation rec {
  name = "wireless-regdb-${version}";
  version = "2016-05-02";

  src = fetchgit {
    sha256 = "04vqhhqm307bx63ihmli751r15b5vrp3011rj1addlkya56wflby";
    url = https://git.kernel.org/pub/scm/linux/kernel/git/sforshee/wireless-regdb.git;
    rev = "refs/tags/master-${version}";
  };

  phases = [ "unpackPhase" "installPhase" ];

  makeFlags = [
    "DESTDIR=$(out)"
    "PREFIX="
  ];

  meta = with stdenv.lib; {
    description = "Wireless regulatory database for CRDA";
    homepage = http://wireless.kernel.org/en/developers/Regulatory/;
    license = licenses.isc;
    platforms = platforms.all;
    maintainers = with maintainers; [ nckx ];
  };
}
