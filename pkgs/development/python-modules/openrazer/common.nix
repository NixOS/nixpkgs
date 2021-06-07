{ lib
, fetchFromGitHub
}: rec {
  version = "3.0.1";
  src = fetchFromGitHub {
    owner = "openrazer";
    repo = "openrazer";
    rev = "v${version}";
    sha256 = "sha256-ptB0jP0kp1Liynkfz0B0OMw6xNQG1s8IvxhgNAdEytM=";
  };
  meta = with lib; {
    homepage = "https://openrazer.github.io/";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ roelvandijk evanjs ];
    platforms = platforms.linux;
  };
}
