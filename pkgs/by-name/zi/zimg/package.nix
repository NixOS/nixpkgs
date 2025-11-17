{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:

stdenv.mkDerivation rec {
  pname = "zimg";
  version = "3.0.6";

  src = fetchFromGitHub {
    owner = "sekrit-twc";
    repo = "zimg";
    rev = "release-${version}";
    sha256 = "sha256-T+/wuTxPK+PLofqJm3dujGqGGXhpdGQLjAttTQPsgOI=";
  };

  outputs = [
    "out"
    "dev"
    "doc"
  ];

  nativeBuildInputs = [ autoreconfHook ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Scaling, colorspace conversion and dithering library";
    homepage = "https://github.com/sekrit-twc/zimg";
    license = licenses.wtfpl;
    platforms = with platforms; unix ++ windows;
    maintainers = with maintainers; [ rnhmjoj ];
  };
}
