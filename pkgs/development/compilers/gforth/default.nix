{ lib, stdenv, fetchFromGitHub, callPackage
, autoreconfHook, texinfo, libffi
}:

let
  swig = callPackage ./swig.nix { };
  bootForth = callPackage ./boot-forth.nix { };
  lispDir = "${placeholder "out"}/share/emacs/site-lisp";
in stdenv.mkDerivation rec {

  pname = "gforth";
  version = "0.7.9_20220127";

  src = fetchFromGitHub {
    owner = "forthy42";
    repo = "gforth";
    rev = version;
    sha256 = "sha256-3+ObHhsPvW44UFiN0GWOhwo7aiqhjwxNY8hw2Wv4MK0=";
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
  ] ++ lib.optionals (stdenv.isDarwin && stdenv.isx86_64) [
    "--build=x86_64-apple-darwin"
  ];

  preConfigure = ''
    mkdir -p ${lispDir}
  '';

  meta = {
    description = "The Forth implementation of the GNU project";
    homepage = "https://github.com/forthy42/gforth";
    license = lib.licenses.gpl3;
    broken = stdenv.isDarwin && stdenv.isAarch64; # segfault when running ./gforthmi
    platforms = lib.platforms.all;
  };
}
