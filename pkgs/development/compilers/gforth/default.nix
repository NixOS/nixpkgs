{ lib, stdenv, callPackage, autoreconfHook, texinfo, fetchFromGitHub
, swig, libffi
}:
let
  version = "0.7.9_20211111";
  sha256 = "sha256-KwYPMWdsL9o8SVcNdENMs4C9ioFBEfyVMqe5bgIrfzs=";
  ## FIXME build https://github.com/GeraldWodni/swig with gforth, then rebuild
  #### This will get rid of the configuration warning
  # swigf = swig.overrideDerivation (old: {
  #   configureFlags = old.configureFlags ++ [
  #     "--enable-forth"
  #   ];
  # });
  bootForth = callPackage ./boot-forth.nix { };

in stdenv.mkDerivation {
  name = "gforth-${version}";
  inherit version;
  src = fetchFromGitHub {
    owner = "forthy42";
    repo = "gforth";
    rev = version;
    inherit sha256;
  };
  patches = [ ./fix-install-txt.patch ];

  nativeBuildInputs = [
    autoreconfHook texinfo bootForth
  ];
  buildInputs = [
    swig libffi
  ];

  passthru = { inherit bootForth; };

  configureFlags = # [ "--enable-lib" ] ++
    lib.optional stdenv.isDarwin [ "--build=x86_64-apple-darwin" ];

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
