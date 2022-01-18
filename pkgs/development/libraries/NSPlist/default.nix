{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation {
  pname = "NSPlist";
  version = "unstable-2017-04-11";

  src = fetchFromGitHub {
    owner = "matthewbauer";
    repo = "NSPlist";
    rev = "713decf06c1ef6c39a707bc99eb45ac9925f2b8a";
    sha256 = "0v4yfiwfd08hmh2ydgy6pnmlzjbd96k78dsla9pfd56ka89aw74r";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    maintainers = with maintainers; [ matthewbauer ];
    description = "Parses .plist files";
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
