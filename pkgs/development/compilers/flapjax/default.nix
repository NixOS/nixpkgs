{cabal, fetchurl, unzip, xhtml, WebBits, WebBitsHtml, JsContracts}:

cabal.mkDerivation ( self: {
  pname = "flapjax";
  version = "2.1";

  src = fetchurl {
    url = https://github.com/brownplt/flapjax/zipball/Flapjax-2.1;
    name = "flapjax-2.1.zip";
    sha256 = "1cp9g570528a813ljnvd1lb389iz0i6511xynf6kzryv8ckc1n7v";
  };

  # The Makefile copies some files to update the flapjax website into
  # missing directories; the -p is to avoid these errors.
  preConfigure = ''
    cd fx
    sed -i 's/mkdir/mkdir -p/' Makefile
    make
    cd ../compiler
  '';

  extraBuildInputs = [ unzip JsContracts ];
  propagatedBuildInputs = [ xhtml WebBits WebBitsHtml ];

  meta = { 
      description = "programming language designed around the demands of modern, client-based Web applications";
      homepage = http://www.flapjax-lang.org/;
      license = "BSD";
  };
})
