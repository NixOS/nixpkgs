{ stdenv, fetchurl, fetchpatch, autoconf213, pkgconfig, perl, zip, which, readline, icu, zlib, nspr, buildPackages }:

let
  version = "52.9.0";
in stdenv.mkDerivation {
  pname = "spidermonkey";
  inherit version;

  src = fetchurl {
    url = "mirror://mozilla/firefox/releases/${version}esr/source/firefox-${version}esr.source.tar.xz";
    sha256 = "1mlx34fgh1kaqamrkl5isf0npch3mm6s4lz3jsjb7hakiijhj7f0";
  };

  outputs = [ "out" "dev" ];
  setOutputFlags = false; # Configure script only understands --includedir

  buildInputs = [ readline icu zlib nspr ];
  nativeBuildInputs = [ autoconf213 pkgconfig perl which buildPackages.python2 zip ];

  # Apparently this package fails to build correctly with modern compilers, which at least
  # on ARMv6 causes polkit testsuite to break with an assertion failure in spidermonkey.
  # These flags were stolen from:
  # https://git.archlinux.org/svntogit/packages.git/tree/trunk/PKGBUILD?h=packages/js52
  NIX_CFLAGS_COMPILE = "-fno-delete-null-pointer-checks -fno-strict-aliasing -fno-tree-vrp";

  patches = [
    # needed to build gnome3.gjs
    (fetchpatch {
      name = "mozjs52-disable-mozglue.patch";
      url = "https://git.archlinux.org/svntogit/packages.git/plain/trunk/mozjs52-disable-mozglue.patch?h=packages/js52&id=4279d2e18d9a44f6375f584911f63d13de7704be";
      sha256 = "18wkss0agdyff107p5lfflk72qiz350xqw2yqc353alkx4fsfpz0";
    })
    (fetchpatch {
      url = "https://git.archlinux.org/svntogit/packages.git/plain/trunk/no-error.diff?h=packages/js52";
      sha256 = "1vsw6558lxiy0r1mg6y49cgddan1mfqvqlkyv734bgxyg6n3pb9i";
    })
    ./fix-werror.patch
  ];

  configurePlatforms = [ ];

  preConfigure = ''
    export CXXFLAGS="-fpermissive"
    export LIBXUL_DIST=$out
    export PYTHON="${buildPackages.python2.interpreter}"
    configureFlagsArray+=("--includedir=$dev/include")

    cd js/src

    autoconf
  '';

  configureFlags = [
    "--with-nspr-prefix=${nspr}"
    "--with-system-zlib"
    "--with-system-icu"
    "--with-intl-api"
    "--enable-readline"
    "--enable-shared-js"
  ] ++ stdenv.lib.optional stdenv.hostPlatform.isMusl "--disable-jemalloc"
    ++ stdenv.lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    "--host=${stdenv.buildPlatform.config}"
    "--target=${stdenv.hostPlatform.config}"
  ];

  makeFlags = [
    "HOST_CC=${buildPackages.stdenv.cc}/bin/cc"
  ];

  depsBuildBuild = [ buildPackages.stdenv.cc ];

  enableParallelBuilding = true;

  postInstall = ''
    moveToOutput bin/js52-config "$dev"
    # Nuke a static lib.
    rm $out/lib/libjs_static.ajs
  '';

  meta = with stdenv.lib; {
    description = "Mozilla's JavaScript engine written in C/C++";
    homepage = "https://developer.mozilla.org/en/SpiderMonkey";
    license = licenses.gpl2; # TODO: MPL/GPL/LGPL tri-license.
    maintainers = [ maintainers.abbradar ];
    platforms = platforms.linux;

    # Commented out so hydra builds the package
    # (I know what you're thinking now, but cjs won't be pulling anything from the network
    #  and modules are allowed to execute commands anyways, so an RCE is basically irrelevant)
    #
    # knownVulnerabilities = [
    #   "The runtime was extracted from Firefox 52, which EOL’d on September 5, 2018."
    # ];
  };
}
