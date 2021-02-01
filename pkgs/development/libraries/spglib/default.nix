{ stdenv, lib, fetchFromGitHub, cmake } :

stdenv.mkDerivation rec {
  pname = "spglib";
  version = "1.16.1";

  src = fetchFromGitHub {
    owner = "atztogo";
    repo = "spglib";
    rev = "v${version}";
    sha256 = "1sk59nnar9npka4mdcfh4154ja46i35y4gbq892kwqidzyfs80in";
  };

  nativeBuildInputs = [ cmake ];

  checkTarget = "check";
  doCheck = true;

  meta = with lib; {
    description = "C library for finding and handling crystal symmetries";
    homepage = "https://atztogo.github.io/spglib/";
    license = licenses.bsd3;
    maintainers = [ maintainers.markuskowa ];
    platforms = platforms.linux;
  };
}
