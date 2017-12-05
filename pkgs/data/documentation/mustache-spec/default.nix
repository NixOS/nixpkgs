{ stdenv, lib, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "mustache-spec-${version}";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "mustache";
    repo = "mustache";
    rev = "v${version}";
    sha256 = "03xrfyjzm5ss6zkdlpl9ypwzcglspcdcnr3f94vj1rjfqm2rxcjw";
  };

  configurePhase = "";
  dontBuild = true;

  installPhase = ''
    mkdir -p $out/{man/man5,doc/html}
    cp man/mustache.5 $out/man/man5
    cp man/mustache.5.html $out/doc/html
  '';

  meta = rec {
    description = "Logic-less templates, specification package";
    longDescription = ''
      Inspired by ctemplate and et, Mustache is a framework-agnostic way to
      render logic-free views.

      Provides the specification as man page and html docs.

      As ctemplates says, "It emphasizes separating logic from presentation: it
      is impossible to embed application logic in this template language."

      For a list of implementations and tips, see ${homepage}.
    '';

    homepage = http://mustache.github.io/;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ profpatsch ];
    platforms = lib.platforms.all;
  };
}
