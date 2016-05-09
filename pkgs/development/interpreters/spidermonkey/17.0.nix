{ stdenv, fetchurl, pkgconfig, nspr, perl, python, zip, libffi, readline }:

stdenv.mkDerivation rec {
  version = "17.0.0";
  name = "spidermonkey-${version}";

  src = fetchurl {
    url = "mirror://mozilla/js/mozjs${version}.tar.gz";
    sha256 = "1fig2wf4f10v43mqx67y68z6h77sy900d1w0pz9qarrqx57rc7ij";
  };

  outputs = [ "dev" "out" "lib" ];

  propagatedBuildInputs = [ nspr ];

  buildInputs = [ pkgconfig perl python zip libffi readline ];

  postUnpack = "sourceRoot=\${sourceRoot}/js/src";

  postPatch = ''
    # Fixes an issue with version detection under perl 5.22.x
    sed -i 's/(defined\((@TEMPLATE_FILE)\))/\1/' config/milestone.pl
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
    "--enable-readline"
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
  };
}

