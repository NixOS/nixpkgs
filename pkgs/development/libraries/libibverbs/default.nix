{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libibverbs-1.1.8";

  src = fetchurl {
    url = "https://www.openfabrics.org/downloads/verbs/${name}.tar.gz";
    sha256 = "13w2j5lrrqxxxvhpxbqb70x7wy0h8g329inzgfrvqv8ykrknwxkw";
  };

  meta = with stdenv.lib; {
    homepage = https://www.openfabrics.org/;
    license = licenses.bsd2;
    platforms = with platforms; linux ++ freebsd;
    maintainers = with maintainers; [ wkennington ];
  };
}
