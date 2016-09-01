{ stdenv, fetchFromGitHub, cmake, boost }:

stdenv.mkDerivation rec {
  name = "libyaml-cpp-${version}";
  version = "0.5.3";

  src = fetchFromGitHub {
    owner = "jbeder";
    repo = "yaml-cpp";
    rev = "release-${version}";
    sha256 = "0qr286q8mwbr4cxz0y0rf045zc071qh3cb804by6w1ydlqciih8a";
  };

  outputs = [ "out" "dev" ];

  buildInputs = [ cmake boost ];

  cmakeFlags = "-DBUILD_SHARED_LIBS=ON";

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "A YAML parser and emitter for C++";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ wkennington ];
  };
}
