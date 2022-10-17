{ stdenv, lib, fetchFromGitHub, cmake, openmp }:

stdenv.mkDerivation rec {
  pname = "spglib";
  version = "2.0.1"; # N.B: if you change this, please update: pythonPackages.spglib

  src = fetchFromGitHub {
    owner = "spglib";
    repo = "spglib";
    rev = "v${version}";
    sha256 = "sha256-0M3GSnNvBNmE4ShW8NNkVrOBGEF9A0C5wd++xnyrcdI=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = lib.optionals stdenv.isDarwin [ openmp ];

  meta = with lib; {
    description = "C library for finding and handling crystal symmetries";
    homepage = "https://spglib.github.io/spglib/";
    changelog = "https://github.com/spglib/spglib/raw/v${version}/ChangeLog";
    license = licenses.bsd3;
    maintainers = [ maintainers.markuskowa ];
    platforms = platforms.all;
  };
}
