{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  unzip,
  zlib,
  versionCheckHook,
}:

stdenv.mkDerivation {
  pname = "uif2iso";
  version = "0.1.7c";

  src = fetchurl {
    url = "https://aluigi.altervista.org/mytoolz/uif2iso.zip";
    sha256 = "1v18fmlzhkkhv8xdc9dyvl8vamwg3ka4dsrg7vvmk1f2iczdx3dp";
  };

  patches = [
    (fetchpatch {
      url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/app-cdr/uif2iso/files/uif2iso-0.1.7c-fix_c23.patch?id=80ed6e7c6b7b628e80f9f76d614c49f583ed5152";
      hash = "sha256-8b18Q6gGVd2pjQzRf17jhrYuaz86crHH26gOJy/krqk=";
      stripLen = 2;
      extraPrefix = "";
    })
  ];

  nativeBuildInputs = [ unzip ];
  buildInputs = [ zlib ];

  installPhase = ''
    make -C . prefix="$out" install;
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Tool for converting single/multi part UIF image files to ISO";
    homepage = "http://aluigi.org/mytoolz.htm#uif2iso";
    license = lib.licenses.gpl1Plus;
    platforms = lib.platforms.linux;
    mainProgram = "uif2iso";
  };
}
