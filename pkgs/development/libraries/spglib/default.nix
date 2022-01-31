{ stdenv, lib, fetchFromGitHub, cmake } :

stdenv.mkDerivation rec {
  pname = "spglib";
  version = "1.16.3";

  src = fetchFromGitHub {
    owner = "atztogo";
    repo = "spglib";
    rev = "v${version}";
    sha256 = "sha256-sM6+RBAVc2aJYlWatdD4nYZkFnaTFVjBzd/VDSSA+kk=";
  };

  nativeBuildInputs = [ cmake ];

  checkTarget = "check";
  doCheck = true;

  meta = with lib; {
    description = "C library for finding and handling crystal symmetries";
    homepage = "https://atztogo.github.io/spglib/";
    license = licenses.bsd3;
    maintainers = [ maintainers.markuskowa ];
    platforms = platforms.all;
  };
}
