{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
}:

stdenv.mkDerivation rec {
  pname = "jbigkit";
  version = "2.1";

  src = fetchurl {
    url = "https://www.cl.cam.ac.uk/~mgk25/jbigkit/download/${pname}-${version}.tar.gz";
    sha256 = "0cnrcdr1dwp7h7m0a56qw09bv08krb37mpf7cml5sjdgpyv0cwfy";
  };

  patches = [
    # Archlinux patch: this helps users to reduce denial-of-service risks, as in CVE-2017-9937
    (fetchpatch {
      url = "https://gitlab.archlinux.org/archlinux/packaging/packages/jbigkit/-/raw/main/0013-new-jbig.c-limit-s-maxmem-maximum-decoded-image-size.patch";
      hash = "sha256-Yq5qCTF7KZTrm4oeWbpctb+QLt3shJUGEReZvd0ey9k=";
    })
    # Archlinux patch: fix heap overflow
    (fetchpatch {
      url = "https://gitlab.archlinux.org/archlinux/packaging/packages/jbigkit/-/raw/main/0015-jbg_newlen-check-for-end-of-file-within-MARKER_NEWLE.patch";
      hash = "sha256-F3qA/btR9D9NfzrNY76X4Z6vG6NrisI36SjCDjS+F5s=";
    })
  ];

  makeFlags = [
    "CC=${stdenv.cc}/bin/${stdenv.cc.targetPrefix}cc"
    "AR=${lib.getBin stdenv.cc.bintools.bintools}/bin/${stdenv.cc.targetPrefix}ar"
    "RANLIB=${lib.getBin stdenv.cc.bintools.bintools}/bin/${stdenv.cc.targetPrefix}ranlib"
  ];

  postPatch = ''
    sed -i 's/^\(CFLAGS.*\)$/\1 -fPIC/' Makefile

    for f in Makefile libjbig/Makefile pbmtools/Makefile; do
        sed -i -E 's/\bar /$(AR) /g;s/\branlib /$(RANLIB) /g' "$f"
    done
  '';

  installPhase = ''
    runHook preInstall

    install -D -m644 libjbig/libjbig.a $out/lib/libjbig.a
    install -D -m644 libjbig/libjbig85.a $out/lib/libjbig85.a
    install -D -m644 libjbig/jbig.h $out/include/jbig.h
    install -D -m644 libjbig/jbig_ar.h $out/include/jbig_ar.h
    install -D -m644 libjbig/jbig85.h $out/include/jbig85.h

    install -d -m755 $out/share/man/man1
    install -m644 pbmtools/*.1* $out/share/man/man1

    install -D -m755 pbmtools/jbgtopbm $out/bin/jbgtopbm
    install -D -m755 pbmtools/pbmtojbg $out/bin/pbmtojbg
    install -D -m755 pbmtools/jbgtopbm85 $out/bin/jbgtopbm85
    install -D -m755 pbmtools/pbmtojbg85 $out/bin/pbmtojbg85

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "http://www.cl.cam.ac.uk/~mgk25/jbigkit/";
    description = "A software implementation of the JBIG1 data compression standard";
    license = licenses.gpl2Plus;
    platforms = platforms.all;
  };
}
