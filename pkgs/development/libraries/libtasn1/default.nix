{ lib
, stdenv
, fetchurl
, fetchpatch
, perl
, texinfo

# for passthru.tests
, gnutls
, samba
, qemu
}:

stdenv.mkDerivation rec {
  pname = "libtasn1";
  version = "4.19.0";

  src = fetchurl {
    url = "mirror://gnu/libtasn1/libtasn1-${version}.tar.gz";
    sha256 = "sha256-FhPwrBz0hNbsDOO4wG1WJjzHJC8cI7MNgtI940WmP3o=";
  };

  # Patch borrowed from alpine to work around a specific test failure with musl libc
  # Upstream is patching this test in their own CI because that CI is using alpine and thus musl
  # https://github.com/gnutls/libtasn1/commit/06e7433c4e587e2ba6df521264138585a63d07c7#diff-037ea159eb0a7cb0ac23b851e66bee30fb838ee8d0d99fa331a1ba65283d37f7R293
  patches = lib.optional stdenv.hostPlatform.isMusl (fetchpatch {
    url = "https://git.alpinelinux.org/aports/plain/main/libtasn1/failed-test.patch?id=aaed9995acc1511d54d5d93e1ea3776caf4aa488";
    sha256 = "sha256-GTfwqEelEsGtLEcBwGRfBZZz1vKXRfWXtMx/409YqX8=";
  });

  outputs = [ "out" "dev" "devdoc" ];
  outputBin = "dev";

  nativeBuildInputs = [ texinfo perl ];

  doCheck = true;
  preCheck = if stdenv.hostPlatform.isDarwin then
    "export DYLD_LIBRARY_PATH=`pwd`/lib/.libs"
  else
    null;

  passthru.tests = {
    inherit gnutls samba qemu;
  };

  meta = with lib; {
    homepage = "https://www.gnu.org/software/libtasn1/";
    description = "ASN.1 library";
    longDescription = ''
      Libtasn1 is the ASN.1 library used by GnuTLS, GNU Shishi and some
      other packages.  The goal of this implementation is to be highly
      portable, and only require an ANSI C89 platform.
    '';
    license = licenses.lgpl2Plus;
    platforms = platforms.all;
  };
}
