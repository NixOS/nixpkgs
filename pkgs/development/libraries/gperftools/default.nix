{ stdenv, fetchurl, fetchpatch, autoreconfHook, libunwind }:

stdenv.mkDerivation rec {
  name = "gperftools-2.8";

  src = fetchurl {
    url = "https://github.com/gperftools/gperftools/releases/download/${name}/${name}.tar.gz";
    sha256 = "0gjiplvday50x695pwjrysnvm5wfvg2b0gmqf6b4bdi8sv6yl394";
  };

  patches = [
    # Add the --disable-general-dynamic-tls configure option:
    # https://bugzilla.redhat.com/show_bug.cgi?id=1483558
    (fetchpatch {
      url = "https://src.fedoraproject.org/rpms/gperftools/raw/f62d87a34f56f64fb8eb86727e34fbc2d3f5294a/f/gperftools-2.7.90-disable-generic-dynamic-tls.patch";
      sha256 = "02falhpaqkl27hl1dib4yvmhwsddmgbw0krb46w31fyf3awb2ydv";
    })
  ];

  nativeBuildInputs = [ autoreconfHook ];

  # tcmalloc uses libunwind in a way that works correctly only on non-ARM linux
  buildInputs = stdenv.lib.optional (stdenv.isLinux && !(stdenv.isAarch64 || stdenv.isAarch32)) libunwind;

  # Disable general dynamic TLS on AArch to support dlopen()'ing the library:
  # https://bugzilla.redhat.com/show_bug.cgi?id=1483558
  configureFlags = stdenv.lib.optional (stdenv.isAarch32 || stdenv.isAarch64)
    "--disable-general-dynamic-tls";

  prePatch = stdenv.lib.optionalString stdenv.isDarwin ''
    substituteInPlace Makefile.am --replace stdc++ c++
    substituteInPlace Makefile.in --replace stdc++ c++
    substituteInPlace libtool --replace stdc++ c++
  '';

  NIX_CFLAGS_COMPILE = stdenv.lib.optionalString stdenv.isDarwin
    "-D_XOPEN_SOURCE -Wno-aligned-allocation-unavailable";

  # some packages want to link to the static tcmalloc_minimal
  # to drop the runtime dependency on gperftools
  dontDisableStatic = true;

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = "https://github.com/gperftools/gperftools";
    description = "Fast, multi-threaded malloc() and nifty performance analysis tools";
    platforms = with platforms; linux ++ darwin;
    license = licenses.bsd3;
    maintainers = with maintainers; [ vcunat ];
  };
}
