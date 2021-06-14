{ fetchFromGitHub, lib, mkDerivation, standard-library }:

mkDerivation rec {
  version = "0.3";
  pname = "functional-linear-algebra";

  buildInputs = [ standard-library ];

  src = fetchFromGitHub {
    repo = "functional-linear-algebra";
    owner = "ryanorendorff";
    rev = "v${version}";
    sha256 = "032gl35x1qzaigc3hbg9dc40zr0nyjld175cb9m8b15rlz9xzjn2";
  };

  preConfigure = ''
    sh generate-everything.sh
  '';

  meta = with lib; {
    homepage = "https://github.com/ryanorendorff/functional-linear-algebra";
    description = ''
      Formalizing linear algebra in Agda by representing matrices as functions
      from one vector space to another.
    '';
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ ryanorendorff ];
  };
}
