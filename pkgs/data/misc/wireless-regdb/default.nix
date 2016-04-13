{ stdenv, fetchgit }:

stdenv.mkDerivation rec {
  name = "wireless-regdb-${version}";
  version = "2016-02-08";

  src = fetchgit {
    sha256 = "0cqnkkcni27ya6apy2ba4im7xj4nrhbcgrahlarvrzbbjkp740m9";
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
