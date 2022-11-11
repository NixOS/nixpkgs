{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "tinyxml-2";
  version = "6.0.0";

  src = fetchFromGitHub {
    repo = "tinyxml2";
    owner = "leethomason";
    rev = version;
    sha256 = "031fmhpah449h3rkyamzzdpzccrrfrvjb4qn6vx2vjm47jwc54qv";
  };

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "A simple, small, efficient, C++ XML parser";
    homepage = "https://www.grinninglizard.com/tinyxml2/index.html";
    platforms = lib.platforms.unix;
    license = lib.licenses.zlib;
  };
}
