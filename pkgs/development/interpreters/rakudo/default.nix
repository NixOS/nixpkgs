{
  stdenv,
  fetchFromGitHub,
  perl,
  icu,
  zlib,
  gmp,
  lib,
  nqp,
  removeReferencesTo,
}:

stdenv.mkDerivation rec {
  pname = "rakudo";
  version = "2025.06";

  # nixpkgs-update: no auto update
  src = fetchFromGitHub {
    owner = "rakudo";
    repo = "rakudo";
    rev = version;
    hash = "sha256-vZ8U18TS+L6P8jTwUxasKH+nrDMElAnGKvgT3nXdpwU=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ removeReferencesTo ];

  buildInputs = [
    icu
    zlib
    gmp
    perl
  ];
  configureScript = "perl ./Configure.pl";
  configureFlags = [
    "--backends=moar"
    "--with-nqp=${nqp}/bin/nqp"
  ];

  disallowedReferences = [ stdenv.cc.cc ];
  postFixup = ''
    remove-references-to -t ${stdenv.cc.cc} "$(readlink -f $out/share/perl6/runtime/dynext/libperl6_ops_moar${stdenv.hostPlatform.extensions.sharedLibrary})"
  '';

  meta = {
    description = "Raku implementation on top of Moar virtual machine";
    homepage = "https://rakudo.org";
    license = lib.licenses.artistic2;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      thoughtpolice
      sgo
      prince213
    ];
  };
}
