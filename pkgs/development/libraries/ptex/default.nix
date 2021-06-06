{ lib, stdenv, fetchFromGitHub, zlib, python, cmake, pkg-config }:

stdenv.mkDerivation rec
{
  pname = "ptex";
  version = "2.3.2";

  src = fetchFromGitHub {
    owner = "wdas";
    repo = "ptex";
    rev = "v${version}";
    sha256 = "1c3pdqszn4y3d86qzng8b0hqdrchnl39adq5ab30wfnrgl2hnm4z";
  };

  outputs = [ "bin" "dev" "out" "lib" ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [ zlib python pkg-config ];

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
