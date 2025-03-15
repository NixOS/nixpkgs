{
  lib,
  stdenv,
  zig,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "zconway";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "CaliOn2";
    repo = pname;
    rev = "6d54221b8ef2e5ba14dabc619908ca3b784ccdc5";
    sha256 = "sha256-vlvyfHdSc3BV8m70ozGZLskFwtbYCd02GucYsbDTNdo=";
  };

  nativeBuildInputs = [
    zig.hook
  ];

  zigBuildFlags = [ "--release=fast" ];

  dontUseZigCheck = true;

  meta = with lib; {
    description = "zConway is a Terminal Conway's game of life simulator written in zig";
    homepage = "https://github.com/github-owner/${pname}";
    license = licenses.agpl3Plus;
    platforms = platforms.unix;
  };
}
