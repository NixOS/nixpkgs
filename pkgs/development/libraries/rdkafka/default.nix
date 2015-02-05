{ stdenv, fetchgit, pkgs }:

stdenv.mkDerivation rec {
  version = "0.8.5";
  name = "rdkafka";

  # Maintenance repo for libtar (Arch Linux uses this)
  src = fetchgit {
    url = "https://github.com/edenhill/librdkafka.git";
    rev = "refs/tags/${version}";
    sha256 = "05a83hmpz1xmnln0wa7n11ijn08zxijdvpdswyymxbdlg69w31y1";
  };

  patchPhase = "patchShebangs .";
  
  buildInputs = [ pkgs.zlib pkgs.perl ];

  meta = with stdenv.lib; {
    description = "librdkafka - Apache Kafka C/C++ client library";
    homepage = "https://github.com/edenhill/librdkafka";
    license = licenses.bsd2;
    platforms = platforms.linux;
    maintainers = [ maintainers.boothead ];
  };
}
