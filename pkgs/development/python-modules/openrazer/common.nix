{ lib
, fetchFromGitHub
}: rec {
  version = "3.1.0";
  src = fetchFromGitHub {
    owner = "openrazer";
    repo = "openrazer";
    rev = "v${version}";
    sha256 = "133szhi0xsfbnjw47xbvyidflxd8fp7pv78vk5wf9s5ch3hpnvxs";
  };
  meta = with lib; {
    homepage = "https://openrazer.github.io/";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ roelvandijk evanjs ];
    platforms = platforms.linux;
  };
}
