{ stdenv, lib, fetchFromGitHub, cmake, gtest, openmp }:

stdenv.mkDerivation rec {
  pname = "spglib";
  version = "2.1.0"; # N.B: if you change this, please update: pythonPackages.spglib

  src = fetchFromGitHub {
    owner = "spglib";
    repo = "spglib";
    rev = "v${version}";
    hash = "sha256-EL3jkzyurc8fnzk9kAdTaEtLfLlLtmaVDFwChfCDOrQ=";
  };

  nativeBuildInputs = [ cmake gtest ];

  buildInputs = lib.optionals stdenv.isDarwin [ openmp ];

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
