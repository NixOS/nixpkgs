{ buildHex, fetchurl }:

buildHex {
  name = "goldrush";
  version = "0.1.7";
  src = fetchurl {
    url = "https://s3.amazonaws.com/s3.hex.pm/tarballs/goldrush-0.1.7.tar";
    sha256 = "1zjgbarclhh10cpgvfxikn9p2ay63rajq96q1sbz9r9w6v6p8jm9";
  };

}
