{
  fetchFromGitHub,
  lib,
  mkDerivation,
  standard-library,
}:

mkDerivation rec {
  version = "0.5.0";
  pname = "functional-linear-algebra";

  buildInputs = [ standard-library ];

  src = fetchFromGitHub {
    repo = "functional-linear-algebra";
    owner = "ryanorendorff";
    rev = "v${version}";
    sha256 = "sha256-3nme/eH4pY6bD0DkhL4Dj/Vp/WnZqkQtZTNk+n1oAyY=";
  };

  preConfigure = ''
    sh generate-everything.sh
  '';

  meta = {
    homepage = "https://github.com/ryanorendorff/functional-linear-algebra";
    description = ''
      Formalizing linear algebra in Agda by representing matrices as functions
      from one vector space to another.
    '';
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ ryanorendorff ];
  };
}
