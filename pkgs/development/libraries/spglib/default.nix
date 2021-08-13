{ stdenv, lib, fetchFromGitHub, cmake } :

stdenv.mkDerivation rec {
  pname = "spglib";
  version = "1.16.2";

  src = fetchFromGitHub {
    owner = "atztogo";
    repo = "spglib";
    rev = "v${version}";
    sha256 = "1sbrk26xyvlhqxxv9cq2ycxwbiafgmh7lf221377zpqq8q3iavd7";
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
