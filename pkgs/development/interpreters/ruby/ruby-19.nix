{ ruby18, fetchurl }:

ruby18.override rec {
  version = "1.9.1-p129";
  name = "ruby-${version}";
  src = fetchurl {
    url = "ftp://ftp.ruby-lang.org/pub/ruby/1.9/ruby-1.9.1-p129.tar.gz";
    sha256 = "0fr52j6xbrq3x4nr93azhz1zhlqb4dar7bi0f0iyqz6iw6naidr7";
  };
}
