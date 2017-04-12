{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation {
  name = "NSPlist-713decf";

  src = fetchFromGitHub {
    owner = "matthewbauer";
    repo = "NSPlist";
    rev = "713decf06c1ef6c39a707bc99eb45ac9925f2b8a";
    sha256 = "0v4yfiwfd08hmh2ydgy6pnmlzjbd96k78dsla9pfd56ka89aw74r";
  };

  buildInputs = [ cmake ];
}
