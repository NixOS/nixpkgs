{ lib
, fetchFromGitHub
}: rec {
  version = "2.9.0";
  src = fetchFromGitHub {
    owner = "openrazer";
    repo = "openrazer";
    rev = "v${version}";
    sha256 = "1js7hq7zx5kj99brffrfaaah283ydkffmmrzsxv4mkd3nnd6rykk";
  };
  meta = with lib; {
    homepage = "https://openrazer.github.io/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ roelvandijk evanjs ];
    platforms = platforms.linux;
  };
}
