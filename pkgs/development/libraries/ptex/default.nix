{ lib, stdenv, fetchFromGitHub, zlib, python2, cmake, pkg-config }:

stdenv.mkDerivation rec
{
  pname = "ptex";
  version = "2.4.1";

  src = fetchFromGitHub {
    owner = "wdas";
    repo = "ptex";
    rev = "v${version}";
    sha256 = "sha256-TuwgZJHvQUqBEFeZYvzpi+tmXB97SkOairYnuUahtSA=";
  };

  outputs = [ "bin" "dev" "out" "lib" ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [ zlib python2 pkg-config ];

  # Can be removed in the next release
  # https://github.com/wdas/ptex/pull/42
  patchPhase = ''
    echo v${version} >version
  '';

  meta = with lib; {
    description = "Per-Face Texture Mapping for Production Rendering";
    homepage = "http://ptex.us/";
    license = licenses.bsd3;
    platforms = platforms.all;
    maintainers = [ maintainers.guibou ];
  };
}
