{ stdenv, fetchgit }:

stdenv.mkDerivation rec {
  name = "wireless-regdb-${version}";
  version = "2016-05-02";

  src = fetchgit {
    sha256 = "1qa741an242wi6gdikkr4ahanphfhwnjg8q2z3rsv8wdha91k895";
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
