{ lib, stdenv, fetchgit }:

stdenv.mkDerivation (finalAttrs: {
  pname = "ustr";
  version = "1.0.4";

  src = fetchgit {
    url = "http://www.and.org/ustr/ustr.git";
    rev = "v${finalAttrs.version}";
    hash = "sha256-pQrQy+S9fVFl8Mop4QmwEAXGiBSheQE4HgAZ4srFz64=";
  };

  # Fixes bogus warnings that failed libsemanage
  patches = [ ./va_args.patch ];

  # Work around gcc5 switch to gnu11
  env.NIX_CFLAGS_COMPILE = "-std=gnu89";

  # Fix detection of stdint.h
  postPatch = ''
    sed -i 's,\(have_stdint_h\)=0,\1=1,g' Makefile
    sed -i 's,\(USTR_CONF_HAVE_STDINT_H\) 0,\1 1,g' ustr-import.in
  '';

  preBuild = ''
    makeFlagsArray+=("prefix=$out")
    makeFlagsArray+=("LDCONFIG=echo")
    makeFlagsArray+=("HIDE=")
  '';

  # Remove debug libraries
  postInstall = ''
    find $out/lib -name \*debug\* -delete
  '';

  meta = with lib; {
    homepage = "http://www.and.org/ustr/";
    description = "Micro String API for C language";
    mainProgram = "ustr-import";
    license = licenses.bsd2;
    maintainers = with lib.maintainers; [ sigmanificient ];
    platforms = platforms.linux;
  };
})
