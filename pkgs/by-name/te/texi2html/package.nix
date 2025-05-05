{
  lib,
  stdenv,
  fetchurl,
  perl,
  gettext,
  versionCheckHook,
  buildPackages,
}:

stdenv.mkDerivation rec {
  pname = "texi2html";
  version = "5.0";

  src = fetchurl {
    url = "mirror://savannah/texi2html/${pname}-${version}.tar.bz2";
    sha256 = "1yprv64vrlcbksqv25asplnjg07mbq38lfclp1m5lj8cw878pag8";
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

  meta = with lib; {
    description = "Perl script which converts Texinfo source files to HTML output";
    mainProgram = "texi2html";
    homepage = "https://www.nongnu.org/texi2html/";
    license = licenses.gpl2;
    maintainers = [ maintainers.marcweber ];
    platforms = platforms.unix;
  };
}
