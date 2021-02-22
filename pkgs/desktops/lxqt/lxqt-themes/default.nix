{ lib
, mkDerivation
, fetchFromGitHub
, cmake
, lxqt-build-tools
, lxqtUpdateScript
}:

mkDerivation rec {
  pname = "lxqt-themes";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "12pbba7a2rk0kjn3hl2lvn90di58w0s5psbq51kz39ah3rlp9dzz";
  };

  nativeBuildInputs = [
    cmake
    lxqt-build-tools
  ];

  passthru.updateScript = lxqtUpdateScript { inherit pname version src; };

  meta = with lib; {
    homepage = "https://github.com/lxqt/lxqt-themes";
    description = "Themes, graphics and icons for LXQt";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
