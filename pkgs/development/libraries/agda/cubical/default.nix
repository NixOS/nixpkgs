{
  lib,
  mkDerivation,
  fetchFromGitHub,
}:

mkDerivation rec {
  pname = "cubical";
  version = "0.8";

  src = fetchFromGitHub {
    repo = pname;
    owner = "agda";
    rev = "v${version}";
    hash = "sha256-KwwN2g2naEo4/rKTz2L/0Guh5LxymEYP53XQzJ6eMjM=";
  };

  postPatch = ''
    # This imports the Everything files, which we don't generate.
    # TODO: remove for the next release
    rm -rf Cubical/README.agda Cubical/Talks/EPA2020.agda
  '';

  meta = with lib; {
    description = "A cubical type theory library for use with the Agda compiler";
    homepage = src.meta.homepage;
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [
      alexarice
      ryanorendorff
      ncfavier
      phijor
    ];
  };
}
