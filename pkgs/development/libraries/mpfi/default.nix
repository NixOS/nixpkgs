{lib, stdenv, fetchFromGitLab, autoreconfHook, texinfo, mpfr}:
stdenv.mkDerivation rec {
  pname = "mpfi";
  version = "1.5.4";

  src = fetchFromGitLab {
    domain = "gitlab.inria.fr";
    owner = pname;
    repo = pname;
    rev = "${version}";
    hash = "sha256-EZMJa6+HRsNyVWy+hZD/srm8Fj02VsHFXXA4WHcwNKM=";
  } + "/${pname}";

  postPatch = ''
    # apparently, they tagged a version with a missing file
    sed -i 's/ div_ext.c / /' src/Makefile.am
  '';

  nativeBuildInputs = [ autoreconfHook texinfo ];
  buildInputs = [ mpfr ];

  meta = {
    description = "A multiple precision interval arithmetic library based on MPFR";
    homepage = "https://gforge.inria.fr/projects/mpfi/";
    license = lib.licenses.lgpl21Plus;
    maintainers = [lib.maintainers.raskin];
    platforms = lib.platforms.unix;
  };
}
