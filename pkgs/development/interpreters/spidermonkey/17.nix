{ stdenv, fetchurl, pkgconfig, nspr, perl, python2, zip, libffi
, enableReadline ? (!stdenv.isDarwin), readline
, libobjc }:

stdenv.mkDerivation rec {
  version = "17.0.0";
  name = "spidermonkey-${version}";

  src = fetchurl {
    url = "mirror://mozilla/js/mozjs${version}.tar.gz";
    sha256 = "1fig2wf4f10v43mqx67y68z6h77sy900d1w0pz9qarrqx57rc7ij";
  };

  outputs = [ "out" "dev" "lib" ];

  propagatedBuildInputs = [ nspr ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ perl python2 zip libffi readline ]
             ++ stdenv.lib.optional enableReadline readline
             ++ stdenv.lib.optional stdenv.isDarwin libobjc;

  postUnpack = "sourceRoot=\${sourceRoot}/js/src";

  patches = [
    (fetchurl {
      name = "jsoptparse-gcc7.patch";
      url = "https://src.fedoraproject.org/cgit/rpms/mozjs17.git/plain/"
          + "mozjs17.0.0-gcc7.patch?id=43b846629a299f";
      sha256 = "17plyaq0jwf9wli4zlgvh4ri3zyk6nj1fiakh3wnd37nsl90raf9";
    })
  ];
  patchFlags = "-p3";

  postPatch = ''
    # Fixes an issue with version detection under perl 5.22.x
    sed -i 's/(defined\((@TEMPLATE_FILE)\))/\1/' config/milestone.pl
  '' + stdenv.lib.optionalString stdenv.isAarch64 ''
    patch -p1 -d ../.. < ${./aarch64-double-conversion.patch}
    patch -p1 -d ../.. < ${./aarch64-48bit-va-fix.patch}
  '';

  preConfigure = ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I${nspr.dev}/include/nspr"
    export LIBXUL_DIST=$out
  '';

  setOutputFlags = false;
  configureFlags = [
    "--libdir=$(lib)/lib"
    "--includedir=$(dev)/include"
    "--enable-threadsafe"
    "--with-system-nspr"
    "--with-system-ffi"
    (if enableReadline then "--enable-readline" else "--disable-readline")
  ];

  # hack around a make problem, see https://github.com/NixOS/nixpkgs/issues/1279#issuecomment-29547393
  preBuild = "touch -- {.,shell,jsapi-tests}/{-lpthread,-ldl}";

  enableParallelBuilding = true;

  doCheck = true;
  preCheck = ''
    rm jit-test/tests/sunspider/check-date-format-tofte.js    # https://bugzil.la/600522

    # Test broken on ARM. Fedora disables it.
    # https://lists.fedoraproject.org/pipermail/scm-commits/Week-of-Mon-20130617/1041155.html
    echo -e '#!${stdenv.shell}\nexit 0' > config/find_vanilla_new_calls

  '' + stdenv.lib.optionalString stdenv.isLinux ''
    paxmark m shell/js17
    paxmark mr jsapi-tests/jsapi-tests
  '';

  postInstall = ''
    rm "$lib"/lib/*.a # halve the output size
    moveToOutput "bin/js*-config" "$dev" # break the cycle
  '';

  meta = with stdenv.lib; {
    description = "Mozilla's JavaScript engine written in C/C++";
    homepage = https://developer.mozilla.org/en/SpiderMonkey;
    # TODO: MPL/GPL/LGPL tri-license.
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.unix;
  };
}
