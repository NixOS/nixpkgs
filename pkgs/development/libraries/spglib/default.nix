{ stdenv, lib, fetchFromGitHub, cmake, openmp }:

stdenv.mkDerivation rec {
  pname = "spglib";
  version = "1.16.5"; # N.B: if you change this, please update: pythonPackages.spglib

  src = fetchFromGitHub {
    owner = "spglib";
    repo = "spglib";
    rev = "v${version}";
    sha256 = "sha256-BbqyL7WJ/jpOls1MmY7VNCN+OlF6u4uz/pZjMAqk87w=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = lib.optionals stdenv.isDarwin [ openmp ];

  checkTarget = "check";
  doCheck = true;

  meta = with lib; {
    description = "C library for finding and handling crystal symmetries";
    homepage = "https://spglib.github.io/spglib/";
    changelog = "https://github.com/spglib/spglib/raw/v${version}/ChangeLog";
    license = licenses.bsd3;
    maintainers = [ maintainers.markuskowa ];
    platforms = platforms.all;
  };
}
