{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  which,
  perl,
  perlPackages,
}:

stdenv.mkDerivation rec {
  pname = "taskopen";
  version = "1.1.5";

  src = fetchFromGitHub {
    owner = "ValiValpas";
    repo = "taskopen";
    rev = "v${version}";
    sha256 = "sha256-/xf7Ph2KKiZ5lgLKk95nCgw/z9wIBmuWf3QGaNebgHg=";
  };

  postPatch = ''
    # We don't need a DESTDIR and an empty string results in an absolute path
    # (due to the trailing slash) which breaks the build.
    sed 's|$(DESTDIR)/||' -i Makefile
  '';

  nativeBuildInputs = [ makeWrapper ];
  buildInputs =
    [ which ]
    ++ (with perlPackages; [
      JSON
      perl
    ]);

  installPhase = ''
    make PREFIX=$out
    make PREFIX=$out install
  '';

  postFixup = ''
    wrapProgram $out/bin/taskopen \
         --set PERL5LIB "$PERL5LIB"
  '';

  meta = with lib; {
    description = "Script for taking notes and open urls with taskwarrior";
    mainProgram = "taskopen";
    homepage = "https://github.com/ValiValpas/taskopen";
    platforms = platforms.linux;
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.winpat ];
  };
}
