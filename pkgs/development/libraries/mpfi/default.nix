{lib, stdenv, fetchFromGitLab, autoreconfHook, texinfo, mpfr}:
stdenv.mkDerivation rec {
  pname = "mpfi";
  version = "1.5.4";

  src = fetchFromGitLab {
    domain = "gitlab.inria.fr";
    owner = "mpfi";
    repo = "mpfi";

    # Apparently there is an upstream off-by-one-commit error in tagging
    # Conditional to allow auto-updaters to try new releases
    # TODO: remove the conditional after an upstream update
    # rev = version;
    rev = if version == "1.5.4" then
      "feab26bc54529417af983950ddbffb3a4c334d4f"
    else version;

    sha256 = "sha256-aj/QmJ38ifsW36JFQcbp55aIQRvOpiqLHwEh/aFXsgo=";
  };

  sourceRoot = "source/mpfi";

  nativeBuildInputs = [ autoreconfHook texinfo ];
  buildInputs = [ mpfr ];

  meta = {
    description = "A multiple precision interval arithmetic library based on MPFR";
    homepage = "http://perso.ens-lyon.fr/nathalie.revol/software.html";
    license = lib.licenses.lgpl21Plus;
    maintainers = [lib.maintainers.raskin];
    platforms = lib.platforms.unix;
  };
}
