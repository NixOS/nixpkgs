{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:

stdenv.mkDerivation rec {
  pname = "zimg";
  version = "3.0.5";

  src = fetchFromGitHub {
    owner = "sekrit-twc";
    repo = "zimg";
    rev = "release-${version}";
    sha256 = "sha256-DCSqHCnOyIvKtIAfprb8tgtzLn67Ix6BWyeIliu0HO4=";
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
