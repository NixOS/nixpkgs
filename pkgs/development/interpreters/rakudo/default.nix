{
  stdenv,
  fetchFromGitHub,
  perl,
  lib,
  nqp,
  removeReferencesTo,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rakudo";
  version = "2025.08";

  # nixpkgs-update: no auto update
  src = fetchFromGitHub {
    owner = "rakudo";
    repo = "rakudo";
    tag = finalAttrs.version;
    hash = "sha256-3O4epBLN6f/XQbCyEgqr6HKiu1qrWirIPt4QrUNzmWY=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ removeReferencesTo ];

  configureScript = "${lib.getExe perl} ./Configure.pl";
  configureFlags = [
    "--backends=moar"
    "--with-nqp=${lib.getExe nqp}"
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
    mainProgram = "rakudo";
  };
})
