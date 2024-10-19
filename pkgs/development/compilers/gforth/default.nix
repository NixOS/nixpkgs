{ lib, stdenv, fetchFromGitHub, callPackage
, autoreconfHook, texinfo, libffi
}:

let
  swig = callPackage ./swig.nix { };
  bootForth = callPackage ./boot-forth.nix { };
  lispDir = "${placeholder "out"}/share/emacs/site-lisp";
in stdenv.mkDerivation rec {

  pname = "gforth";
  version = "0.7.9_20230518";

  src = fetchFromGitHub {
    owner = "forthy42";
    repo = "gforth";
    rev = version;
    hash = "sha256-rXtmmENBt9RMdLPq8GDyndh4+CYnCmz6NYpe3kH5OwU=";
  };

  nativeBuildInputs = [
    autoreconfHook texinfo bootForth swig
  ];
  buildInputs = [
    libffi
  ];

  passthru = { inherit bootForth; };

  configureFlags = [
    "--with-lispdir=${lispDir}"
  ] ++ lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64) [
    "--build=x86_64-apple-darwin"
  ];

  preConfigure = ''
    mkdir -p ${lispDir}
  '';

  meta = {
    description = "Forth implementation of the GNU project";
    homepage = "https://github.com/forthy42/gforth";
    license = lib.licenses.gpl3;
    broken = stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64; # segfault when running ./gforthmi
    platforms = lib.platforms.all;
  };
}
