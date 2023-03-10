{ lib, mkDerivation, fetchFromGitHub }:

mkDerivation rec {
  version = "unstable-2022-01-14";
  pname = "agda-prelude";

  src = fetchFromGitHub {
    owner = "UlfNorell";
    repo = "agda-prelude";
    rev = "3d143d6d0a3f75966602480665623e87233ff93e";
    hash = "sha256-ILhXDq788vrceMp5mCiQUMrJxeLPtS4yGtvMHMYxzg8=";
  };

  preConfigure = ''
    cd test
    make everything
    mv Everything.agda ..
    cd ..
  '';

  meta = with lib; {
    homepage = "https://github.com/UlfNorell/agda-prelude";
    description = "Programming library for Agda";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with maintainers; [ mudri alexarice turion ];
  };
}
