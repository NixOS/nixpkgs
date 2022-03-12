{ stdenv, lib, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "cgreen";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "cgreen-devs";
    repo = "cgreen";
    rev = version;
    sha256 = "sha256-MVVkdg/8ujwlmpadjFjm755frEl3B9hFadunezYvURg=";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    homepage = "https://github.com/cgreen-devs/cgreen";
    description = "The Modern Unit Test and Mocking Framework for C and C++";
    license = licenses.isc;
    maintainers = [ maintainers.nichtsfrei ];
    platforms = platforms.unix;
  };
}
