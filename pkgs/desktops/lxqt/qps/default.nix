{ lib, mkDerivation, fetchFromGitHub, cmake, qtbase, qtx11extras, qttools,
  lxqt-build-tools }:

mkDerivation rec {
  pname = "qps";
  version = "1.10.20";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "1g8j4cjy5x33jzjkx6vwyl5qbf9i2z2w01ipgk7nrik5drf9crbf";
  };

  nativeBuildInputs = [ cmake lxqt-build-tools ];

  buildInputs = [ qtbase qtx11extras qttools ];

  meta = with lib; {
    description = "The Qt process manager";
    homepage = https://github.com/lxqt/qps;
    license = licenses.gpl2;
    maintainers = with maintainers; [ romildo ];
    platforms = with platforms; unix;
  };
}
