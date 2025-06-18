{
  lib,
  stdenv,
  fetchurl,
  perl,
  gettext,
  versionCheckHook,
  buildPackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "texi2html";
  version = "5.0";

  src = fetchurl {
    url = "mirror://savannah/texi2html/texi2html-${finalAttrs.version}.tar.bz2";
    hash = "sha256-6KmLDuIMSVpquJQ5igZe9YAnLb1aFbGxnovRvInZ+fo=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    perl
  ];

  buildInputs = [
    gettext
    perl
  ];

  postPatch = ''
    patchShebangs --build separated_to_hash.pl
  '';

  postInstall = ''
    patchShebangs --host --update $out/bin/*
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  meta = {
    description = "Perl script which converts Texinfo source files to HTML output";
    mainProgram = "texi2html";
    homepage = "https://www.nongnu.org/texi2html/";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.marcweber ];
    platforms = lib.platforms.unix;
  };
})
