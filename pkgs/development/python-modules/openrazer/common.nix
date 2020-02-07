{ stdenv
, fetchFromGitHub
}: rec {
  version = "2.7.0";
  src = fetchFromGitHub {
    owner = "openrazer";
    repo = "openrazer";
    rev = "v${version}";
    sha256 = "013r9q4xg2xjmyxybx07zsl2b5lm9vw843anx22ygpvxz1qgz9hp";
  };
  meta = with stdenv.lib; {
    homepage = https://openrazer.github.io/;
    license = licenses.gpl2;
    maintainers = with maintainers; [ roelvandijk evanjs ];
    platforms = platforms.linux;
  };
}
