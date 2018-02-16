{ stdenv, fetchurl, fetchpatch,  dejagnu, doCheck ? false
, buildPlatform, hostPlatform
}:

stdenv.mkDerivation rec {
  name = "libffi-3.2.1";

  src = fetchurl {
    url = "ftp://sourceware.org/pub/libffi/${name}.tar.gz";
    sha256 = "0dya49bnhianl0r65m65xndz6ls2jn1xngyn72gd28ls3n7bnvnh";
  };

  patches = stdenv.lib.optional stdenv.isCygwin ./3.2.1-cygwin.patch
    ++ stdenv.lib.optional stdenv.isAarch64 (fetchpatch {
      url = https://src.fedoraproject.org/rpms/libffi/raw/ccffc1700abfadb0969495a6e51b964117fc03f6/f/libffi-aarch64-rhbz1174037.patch;
      sha256 = "1vpirrgny43hp0885rswgv3xski8hg7791vskpbg3wdjdpb20wbc";
    })
    ++ stdenv.lib.optional hostPlatform.isMusl (fetchpatch {
      name = "gnu-linux-define.patch";
      url = "https://git.alpinelinux.org/cgit/aports/plain/main/libffi/gnu-linux-define.patch?id=bb024fd8ec6f27a76d88396c9f7c5c4b5800d580";
      sha256 = "11pvy3xkhyvnjfyy293v51f1xjy3x0azrahv1nw9y9mw8bifa2j2";
    })
    ++ stdenv.lib.optionals stdenv.isMips [
      (fetchpatch {
        name = "0001-mips-Use-compiler-internal-define-for-linux.patch";
        url = "http://cgit.openembedded.org/openembedded-core/plain/meta/recipes-support/libffi/libffi/0001-mips-Use-compiler-internal-define-for-linux.patch?id=318e33a708378652edcf61ce7d9d7f3a07743000";
        sha256 = "1gc53lw90p6hc0cmhj3csrwincfz7va5ss995ksw5gm0yrr9mrvb";
      })
      (fetchpatch {
        name = "0001-mips-fix-MIPS-softfloat-build-issue.patch";
        url = "http://cgit.openembedded.org/openembedded-core/plain/meta/recipes-support/libffi/libffi/0001-mips-fix-MIPS-softfloat-build-issue.patch?id=318e33a708378652edcf61ce7d9d7f3a07743000";
        sha256 = "0l8xgdciqalg4z9rcwyk87h8fdxpfv4hfqxwsy2agpnpszl5jjdq";
      })
    ];

  outputs = [ "out" "dev" "man" "info" ];

  buildInputs = stdenv.lib.optional doCheck dejagnu;

  configureFlags = [
    "--with-gcc-arch=generic" # no detection of -march= or -mtune=
    "--enable-pax_emutramp"
  ];

  inherit doCheck;

  dontStrip = hostPlatform != buildPlatform; # Don't run the native `strip' when cross-compiling.

  # Install headers and libs in the right places.
  postFixup = ''
    mkdir -p "$dev/"
    mv "$out/lib/${name}/include" "$dev/include"
    rmdir "$out/lib/${name}"
    substituteInPlace "$dev/lib/pkgconfig/libffi.pc" \
      --replace 'includedir=''${libdir}/libffi-3.2.1' "includedir=$dev"
  '';

  meta = with stdenv.lib; {
    description = "A foreign function call interface library";
    longDescription = ''
      The libffi library provides a portable, high level programming
      interface to various calling conventions.  This allows a
      programmer to call any function specified by a call interface
      description at run-time.

      FFI stands for Foreign Function Interface.  A foreign function
      interface is the popular name for the interface that allows code
      written in one language to call code written in another
      language.  The libffi library really only provides the lowest,
      machine dependent layer of a fully featured foreign function
      interface.  A layer must exist above libffi that handles type
      conversions for values passed between the two languages.
    '';
    homepage = http://sourceware.org/libffi/;
    # See http://github.com/atgreen/libffi/blob/master/LICENSE .
    license = licenses.free;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
