{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "cmark";
  version = "0.30.0";

  src = fetchFromGitHub {
    owner = "jgm";
    repo = pname;
    rev = version;
    sha256 = "sha256-SU31kJL+8wt57bGW5fNeXjXPgPeCXZIknZwDxMXCfdc=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    # https://github.com/commonmark/cmark/releases/tag/0.30.0
    # recommends distributions dynamically link
    "-DCMARK_STATIC=OFF"
  ];

  doCheck = !stdenv.isDarwin;

  preCheck = ''
    export LD_LIBRARY_PATH=$(readlink -f ./src)
  '';

  meta = with lib; {
    description = "CommonMark parsing and rendering library and program in C";
    homepage = "https://github.com/jgm/cmark";
    maintainers = [ maintainers.michelk ];
    platforms = platforms.unix;
    license = licenses.bsd2;
  };
}
