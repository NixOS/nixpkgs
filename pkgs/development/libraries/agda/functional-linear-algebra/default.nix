{ fetchFromGitHub, lib, mkDerivation, standard-library }:

mkDerivation rec {
  version = "0.4";
  pname = "functional-linear-algebra";

  buildInputs = [ standard-library ];

  src = fetchFromGitHub {
    repo = "functional-linear-algebra";
    owner = "ryanorendorff";
    rev = "v${version}";
    sha256 = "05jk3792k9xf8iiwzm2hwlvd25f2pqqr3gppmqjf8xb9199i8fk0";
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
