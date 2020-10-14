{ fetchFromGitHub, lib, stdenv, mkDerivation, standard-library }:

mkDerivation rec {
  version = "0.1";
  pname = "functional-linear-algebra";

  buildInputs = [ standard-library ];

  src = fetchFromGitHub {
    repo = "functional-linear-algebra";
    owner = "ryanorendorff";
    rev = "v${version}";
    sha256 = "09ri3jmgp9jjwi1mzv4c3w6rvcmyx6spa2qxpwlcn0f4bmfva6wm";
  };

  meta = with stdenv.lib; {
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
