{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, meson
, ninja
}:
stdenv.mkDerivation rec {
  pname = "cgif";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "dloebl";
    repo = "cgif";
    rev = "V${version}";
    sha256 = "sha256-G7WWWdpZIb3A6Xt2HNZfAdg+uBKdOYJoy3FdBio98OY=";
  };

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
  ];

  meta = with lib; {
    homepage = "https://github.com/dloebl/cgif";
    description = "GIF encoder written in C";
    license = licenses.mit;
    maintainers = with maintainers; [ joedupuis ];
    platforms = platforms.unix;
  };
}
