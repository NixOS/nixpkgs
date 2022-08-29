{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "miniz";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "richgel999";
    repo = pname;
    rev = version;
    sha256 = "sha256-7hc/yNJh4sD5zGQLeHjowbUtV/1mUDQre1tp9yKMSSY=";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "Single C source file zlib-replacement library";
    homepage = "https://github.com/richgel999/miniz";
    license = licenses.mit;
    maintainers = with maintainers; [ astro ];
    platforms = platforms.unix;
  };
}
