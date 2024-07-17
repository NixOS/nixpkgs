{
  lib,
  stdenv,
  fetchFromGitHub,
  readline,
  autoreconfHook,
  autoconf-archive,
  gmp,
  flex,
  bison,
}:

stdenv.mkDerivation rec {
  pname = "bic";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "hexagonal-sun";
    repo = pname;
    rev = "v${version}";
    sha256 = "1ws46h1ngzk14dspmsggj9535yl04v9wh8v4gb234n34rdkdsyyw";
  };

  buildInputs = [
    readline
    gmp
  ];
  nativeBuildInputs = [
    autoreconfHook
    autoconf-archive
    bison
    flex
  ];

  meta = with lib; {
    description = "A C interpreter and API explorer";
    mainProgram = "bic";
    longDescription = ''
      bic This a project that allows developers to explore and test C-APIs using a
      read eval print loop, also known as a REPL.
    '';
    license = with licenses; [ gpl2Plus ];
    homepage = "https://github.com/hexagonal-sun/bic";
    platforms = platforms.unix;
    maintainers = with maintainers; [ hexagonal-sun ];
    # never built on aarch64-darwin since first introduction in nixpkgs
    broken = stdenv.isDarwin && stdenv.isAarch64;
  };
}
