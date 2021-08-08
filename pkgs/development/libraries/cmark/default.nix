{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "cmark";
  version = "0.30.1";

  src = fetchFromGitHub {
    owner = "jgm";
    repo = pname;
    rev = version;
    sha256 = "sha256-UjDM2N6gCwO94F1nW3qCP9JX42MYAicAuGTKAXMy1Gg=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    # https://github.com/commonmark/cmark/releases/tag/0.30.1
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
