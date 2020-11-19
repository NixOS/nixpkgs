{ stdenv
, fetchFromGitHub
}: rec {
  version = "2.8.0";
  src = fetchFromGitHub {
    owner = "openrazer";
    repo = "openrazer";
    rev = "v${version}";
    sha256 = "0mwg6b2y3wfpvgxb9lznwblb3bnrayn858nc4fbbg76zdp5bk5ky";
  };
  meta = with stdenv.lib; {
    homepage = "https://openrazer.github.io/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ roelvandijk evanjs ];
    platforms = platforms.linux;
  };
}
