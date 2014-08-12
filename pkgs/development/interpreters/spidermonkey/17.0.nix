{ stdenv, fetchurl, pkgconfig, nspr, perl, python, zip }:

stdenv.mkDerivation rec {
  version = "17.0.0";
  name = "spidermonkey-${version}";

  src = fetchurl {
    url = "http://ftp.mozilla.org/pub/mozilla.org/js/mozjs${version}.tar.gz";
    sha256 = "1fig2wf4f10v43mqx67y68z6h77sy900d1w0pz9qarrqx57rc7ij";
  };

  propagatedBuildInputs = [ nspr ];

  buildInputs = [ pkgconfig perl python zip ];

  postUnpack = "sourceRoot=\${sourceRoot}/js/src";

  preConfigure = ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I${nspr}/include/nspr"
    export LIBXUL_DIST=$out
  '';

  configureFlags = [ "--enable-threadsafe" "--with-system-nspr" ];

  # hack around a make problem, see https://github.com/NixOS/nixpkgs/issues/1279#issuecomment-29547393
  preBuild = "touch -- {.,shell,jsapi-tests}/{-lpthread,-ldl}";

  enableParallelBuilding = true;

  doCheck = true;
  preCheck = ''
    rm jit-test/tests/sunspider/check-date-format-tofte.js    # https://bugzil.la/600522

    paxmark m shell/js17
    paxmark mr jsapi-tests/jsapi-tests
  '';

  meta = with stdenv.lib; {
    description = "Mozilla's JavaScript engine written in C/C++";
    homepage = https://developer.mozilla.org/en/SpiderMonkey;
    # TODO: MPL/GPL/LGPL tri-license.
    maintainers = [ maintainers.goibhniu ];
  };
}

