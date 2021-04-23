{ lib
, fetchFromGitHub
}: rec {
  version = "3.0.0";
  src = fetchFromGitHub {
    owner = "openrazer";
    repo = "openrazer";
    rev = "v${version}";
    sha256 = "sha256-gw6Qt9BntPcF3zw19PXftDbhoCeBr8hwrujy51rb5Fc=";
  };
  meta = with lib; {
    homepage = "https://openrazer.github.io/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ roelvandijk evanjs ];
    platforms = platforms.linux;
  };
}
