{ stdenv, fetchFromGitHub, cmake, boost }:

stdenv.mkDerivation rec {
  name = "libyaml-cpp-${version}";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "jbeder";
    repo = "yaml-cpp";
    rev = "yaml-cpp-${version}";
    sha256 = "16x53p9gfch7gpyg865j7m1zhqsixx2hbbd206ffjv0ip8cjipjf";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ cmake ];

  cmakeFlags = "-DBUILD_SHARED_LIBS=ON";

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "A YAML parser and emitter for C++";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ andir ];
  };
}
