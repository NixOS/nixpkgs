{ lib
, stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "tinyssh";
  version = "20241201";

  src = fetchFromGitHub {
    owner = "janmojzis";
    repo = "tinyssh";
    tag = version;
    hash = "sha256-bcQDKDpd7HFnmJAyqcO+BQMGV1pCHuS+OhFPJSOMInI=";
  };

  preConfigure = ''
    echo /bin       > conf-bin
    echo /share/man > conf-man
  '';

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isClang "-Wno-error=implicit-function-declaration";

  DESTDIR = placeholder "out";

  meta = {
    description = "Minimalistic SSH server";
    homepage = "https://tinyssh.org";
    changelog = "https://github.com/janmojzis/tinyssh/releases/tag/${version}";
    license = lib.licenses.cc0;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ kaction ];
  };
}
