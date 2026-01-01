{
<<<<<<< HEAD
  fetchFromGitHub,
  lib,
  nqp,
  perl,
  stdenv,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rakudo";
  version = "2025.12";
=======
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
  version = "2025.06.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  # nixpkgs-update: no auto update
  src = fetchFromGitHub {
    owner = "rakudo";
    repo = "rakudo";
<<<<<<< HEAD
    tag = finalAttrs.version;
    fetchSubmodules = true;
    hash = "sha256-rCLlLxFexk2fzuuSMrJjbwhgU+HgJNX6Ect6uCsuJmo=";
  };

  postPatch = ''
    substituteInPlace src/core.c/CompUnit/Repository/Installation.rakumod \
      --subst-var out
  '';

  patches = [
    ./rakudo-plain-wrapper.patch
  ];

  configureScript = "${lib.getExe perl} ./Configure.pl";
  configureFlags = [
    "--backends=moar"
    "--with-nqp=${lib.getExe nqp}"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
=======
    rev = version;
    hash = "sha256-cofiX6VHHeki8GQcMamDyPYoVMUKiuhKVz8Gh8L9qu0=";
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
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
<<<<<<< HEAD
    mainProgram = "rakudo";
  };
})
=======
  };
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
