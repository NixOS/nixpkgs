{ ruby18, fetchurl }:

ruby18.override rec {
  version = "1.9.1-p243";
  name = "ruby-${version}";
  src = fetchurl {
    url = "ftp://ftp.ruby-lang.org/pub/ruby/1.9/ruby-${version}.tar.gz";
    sha256 = "1r4bls76dg97lqgwkxi6kbxzirkvjm21d4i2qyz469lnncvqwn9i";
  };

  passthru = {
    libPath = "lib/ruby-1.9";
  };
}
