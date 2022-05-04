{ lib, stdenv, fetchFromGitHub, callPackage
, autoreconfHook, texinfo, libffi
}:

let
  swig = callPackage ./swig.nix { };
  bootForth = callPackage ./boot-forth.nix { };
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

  configureFlags = lib.optional stdenv.isDarwin [ "--build=x86_64-apple-darwin" ];

  postInstall = ''
    mkdir -p $out/share/emacs/site-lisp
    cp gforth.el $out/share/emacs/site-lisp/
  '';

  meta = {
    description = "The Forth implementation of the GNU project";
    homepage = "https://github.com/forthy42/gforth";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.all;
  };
}
