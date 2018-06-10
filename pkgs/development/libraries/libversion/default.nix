{ stdenv, fetchFromGitHub, cmake }:

let
  version = "2.6.0";
in
stdenv.mkDerivation {
  name = "libversion-${version}";

  src = fetchFromGitHub {
    owner = "repology";
    repo = "libversion";
    rev = version;
    sha256 = "0krhfycva3l4rhac5kx6x1a6fad594i9i77vy52rwn37j62bm601";
  };

  nativeBuildInputs = [ cmake ];

  doCheck = true;
  checkTarget = "test";

  meta = with stdenv.lib; {
    description = "Advanced version string comparison library";
    homepage = https://github.com/repology/libversion;
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ ryantm ];
    platforms = platforms.unix;
  };
}
