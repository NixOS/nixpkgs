{ stdenv, fetchurl, fetchpatch }:

let
  patch-argp-fmtstream = fetchpatch {
    name = "patch-argp-fmtstream.h";
    url = "https://raw.githubusercontent.com/Homebrew/formula-patches/b5f0ad3/argp-standalone/patch-argp-fmtstream.h";
    sha256 = "5656273f622fdb7ca7cf1f98c0c9529bed461d23718bc2a6a85986e4f8ed1cb8";
  };

  patch-throw-in-funcdef = fetchpatch {
    name = "argp-standalone-1.3-throw-in-funcdef.patch";
    url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/sys-libs/argp-standalone/files/argp-standalone-1.3-throw-in-funcdef.patch?id=409d0e2a9c9c899fb1fb04cc808fe0aff3f745ca";
    sha256 = "0b2b4l1jkvmnffl22jcn4ydzxy2i7fnmmnfim12f0yg5pb8fs43c";
  };

  patch-shared = fetchpatch {
    name = "argp-standalone-1.3-shared.patch";
    url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/sys-libs/argp-standalone/files/argp-standalone-1.3-shared.patch?id=409d0e2a9c9c899fb1fb04cc808fe0aff3f745ca";
    sha256 = "1xx2zdc187a1m2x6c1qs62vcrycbycw7n0q3ks2zkxpaqzx2dgkw";
  };
in
stdenv.mkDerivation {
  name = "argp-standalone-1.3";

  src = fetchurl {
    url = "https://www.lysator.liu.se/~nisse/misc/argp-standalone-1.3.tar.gz";
    sha256 = "dec79694da1319acd2238ce95df57f3680fea2482096e483323fddf3d818d8be";
  };

  patches =
       stdenv.lib.optionals stdenv.hostPlatform.isDarwin [ patch-argp-fmtstream ]
    ++ stdenv.lib.optionals stdenv.hostPlatform.isLinux [ patch-throw-in-funcdef patch-shared ];

  patchFlags = stdenv.lib.optional stdenv.hostPlatform.isDarwin "-p0";

  preConfigure = stdenv.lib.optionalString stdenv.hostPlatform.isLinux "export CFLAGS='-fgnu89-inline'";

  postInstall = ''
    mkdir -p $out/lib $out/include
    cp libargp.a $out/lib
    cp argp.h $out/include
  '';

  doCheck = true;

  makeFlags = [ "AR:=$(AR)" ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = "https://www.lysator.liu.se/~nisse/misc/";
    description = "Standalone version of arguments parsing functions from GLIBC";
    platforms = with platforms; darwin ++ [ "x86_64-linux" ];
    maintainers = with maintainers; [ amar1729 ];
    license = licenses.gpl2;
  };
}
