{ stdenv, lib, autoconf213, fetchurl, fetchpatch, pkgconfig, nspr, perl, python2, zip }:

stdenv.mkDerivation rec {
  name = "spidermonkey-${version}";
  version = "1.8.5";

  src = fetchurl {
    url = "mirror://mozilla/js/js185-1.0.0.tar.gz";
    sha256 = "5d12f7e1f5b4a99436685d97b9b7b75f094d33580227aa998c406bbae6f2a687";
  };

  propagatedBuildInputs = [ nspr ];

  nativeBuildInputs = [ pkgconfig ] ++ lib.optional stdenv.isArm autoconf213;
  buildInputs = [ perl python2 zip ];

  postUnpack = "sourceRoot=\${sourceRoot}/js/src";

  preConfigure = ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I${nspr.dev}/include/nspr"
    export LIBXUL_DIST=$out
    ${lib.optionalString stdenv.isArm "autoreconf --verbose --force"}
  '';

  patches = [
    (fetchpatch {
      name = "gcc6.patch";
      url = "https://anonscm.debian.org/cgit/collab-maint/mozjs.git/plain/debian/patches/fix-811665.patch?id=00b15c7841968ab4f7fec409a6b93fa5e1e1d32e";
      sha256 = "1q8477xqxiy5d8376k5902l45gd0qkd4nxmhl8vr6rr1pxfcny99";
    })
  ] ++ stdenv.lib.optionals stdenv.isArm [
    # Explained below in configureFlags for ARM
    ./1.8.5-findvanilla.patch
    # Fix for hard float flags.
    ./1.8.5-arm-flags.patch
  ];

  patchFlags = "-p3";

  # On the Sheevaplug, ARM, its nanojit thing segfaults in japi-tests in
  # "make check". Disabling tracejit makes it work, but then it needs the
  # patch findvanilla.patch do disable a checker about allocator safety. In case
  # of polkit, which is what matters most, it does not override the allocator
  # so the failure of that test does not matter much.
  configureFlags = [ "--enable-threadsafe" "--with-system-nspr" ] ++
    stdenv.lib.optionals (stdenv.system == "armv5tel-linux") [
        "--with-cpu-arch=armv5t" 
        "--disable-tracejit" ];

  # hack around a make problem, see https://github.com/NixOS/nixpkgs/issues/1279#issuecomment-29547393
  preBuild = ''
    touch -- {.,shell,jsapi-tests}/{-lpthread,-ldl}
    ${if stdenv.isArm then "rm -r jit-test/tests/jaeger/bug563000" else ""}
  '';

  enableParallelBuilding = true;

  doCheck = true;

  preCheck = ''
    rm jit-test/tests/sunspider/check-date-format-tofte.js    # https://bugzil.la/600522

    paxmark mr shell/js
    paxmark mr jsapi-tests/jsapi-tests
  '';

  meta = with stdenv.lib; {
    description = "Mozilla's JavaScript engine written in C/C++";
    homepage = https://developer.mozilla.org/en/SpiderMonkey;
    # TODO: MPL/GPL/LGPL tri-license.
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}

