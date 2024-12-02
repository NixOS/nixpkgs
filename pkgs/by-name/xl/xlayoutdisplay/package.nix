{ lib, stdenv, fetchFromGitHub, pkg-config, xorg, boost, gtest }:

stdenv.mkDerivation rec {
  pname = "xlayoutdisplay";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "alex-courtis";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-A37jFhVTW/3QNEf776Oi3ViRK+ebOPRTsEQqdmNhA7E=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = with xorg; [ libX11 libXrandr libXcursor boost ];
  nativeCheckInputs = [ gtest ];

  doCheck = true;
  checkTarget = "gtest";

  makeFlags = [ "PREFIX=${placeholder "out"}" ];
  enableParallelBuilding = true;

  meta = with lib; {
    description = "Detects and arranges linux display outputs, using XRandR for detection and xrandr for arrangement";
    homepage = "https://github.com/alex-courtis/xlayoutdisplay";
    maintainers = with maintainers; [ dtzWill ];
    license = licenses.asl20;
    platforms = platforms.linux;
    mainProgram = "xlayoutdisplay";
  };
}
