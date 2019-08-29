{ stdenv
, fetchFromGitHub
}: rec {
  version = "2.6.0";
  src = fetchFromGitHub {
    owner = "openrazer";
    repo = "openrazer";
    rev = "v${version}";
    sha256 = "1s5irs3avrlp891mxan3z8p55ias9rq26rqp2qrlcc6i4vl29di0";
  };
  meta = with stdenv.lib; {
    homepage = https://openrazer.github.io/;
    license = licenses.gpl2;
    maintainers = with maintainers; [ roelvandijk ];
    platforms = platforms.linux;
  };
}
