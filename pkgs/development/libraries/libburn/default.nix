{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libburn-${version}";
  version = "1.4.2.pl01";

  src = fetchurl {
    url = "http://files.libburnia-project.org/releases/${name}.tar.gz";
    sha256 = "1nqfm24dm2csdnhsmpgw9cwcnkwvqlvfzsm9bhr6yg7bbmzwvkrk";
  };

  meta = with stdenv.lib; {
    homepage = http://libburnia-project.org/;
    description = "A library by which preformatted data get onto optical media: CD, DVD, BD (Blu-Ray)";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ abbradar ];
  };
}
