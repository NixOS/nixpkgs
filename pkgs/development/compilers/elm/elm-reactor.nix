{ unzip, fetchurl, fetchFromGitHub, cabal, blazeHtml, blazeMarkup, cmdargs, elmCompiler, elmMake, filepath
, fsnotify, HTTP, mtl, snapCore, snapServer, systemFilepath, text
, time, transformers, unorderedContainers, websockets
, websocketsSnap
}:

cabal.mkDerivation (self: rec {
  pname = "elm-reactor";
  version = "0.3";
  isLibrary = false;
  isExecutable = true;
  buildTools = [ unzip ];

  src = fetchFromGitHub {
    owner = "elm-lang";
	repo = "elm-reactor";
	rev = "176ff8e05e4bb7474752da1b3455c83d6181d594";
	sha256 = "1marjqlmmq3a74g9f3ngk90h9mkhillcdwfsys6x0nqj6qirw4ph";
  };
  elmLangCore = fetchurl {
    url = "https://github.com/elm-lang/core/archive/1.1.0.zip";
    sha256 = "1fhvghjsay1p82k13039wbd02k439yplv2rh9zr77zvcbih6a31j";
  };
  elmHtml = fetchurl {
	url = "https://github.com/evancz/elm-html/archive/1.1.0.zip";
    sha256 = "01wshabxsdrxcxs2nn3dhk7n8720sp3prpkahhx36vvprdh05l4q";
  };
  elmMarkdown = fetchurl {
	url = "https://github.com/evancz/elm-markdown/archive/1.1.2.zip";
	sha256 = "14y1wp28za50zypdzyvl5d57hkm0v3rgnzm5klv3jcbd625kr9bg";
  };
  virtualDom = fetchurl {
	url = "https://github.com/evancz/virtual-dom/archive/1.1.0.zip";
	sha256 = "08dr7q0x1ycgj5b15s2kn1a45iw350gzq65c3lxp47xfffq1vz91";
  };
  elmStuff = ./elm-reactor-exact-dependencies.json;

  preConfigure = ''
	unzip -d $TEMPDIR -q ${elmLangCore}
	mkdir -p elm-stuff/packages/elm-lang/core/1.1.0
	cp -pr $TEMPDIR/core-1.1.0/* elm-stuff/packages/elm-lang/core/1.1.0/

	unzip -d $TEMPDIR -q ${elmHtml}
	mkdir -p elm-stuff/packages/evancz/elm-html/1.1.0
	cp -pr $TEMPDIR/elm-html-1.1.0/* elm-stuff/packages/evancz/elm-html/1.1.0

	unzip -d $TEMPDIR -q ${elmMarkdown}
	mkdir -p elm-stuff/packages/evancz/elm-markdown/1.1.2
	cp -pr $TEMPDIR/elm-markdown-1.1.2/* elm-stuff/packages/evancz/elm-markdown/1.1.2

	unzip -d $TEMPDIR -q ${virtualDom}
	mkdir -p elm-stuff/packages/evancz/virtual-dom/1.1.0
	cp -pr $TEMPDIR/virtual-dom-1.1.0/* elm-stuff/packages/evancz/virtual-dom/1.1.0

    cp ${elmStuff} elm-stuff/exact-dependencies.json
  '';
  buildDepends = [
    blazeHtml blazeMarkup cmdargs elmCompiler filepath fsnotify HTTP
    mtl snapCore snapServer systemFilepath text time transformers
    unorderedContainers websockets websocketsSnap elmMake
  ];
  meta = {
    homepage = "http://elm-lang.org";
    description = "Interactive development tool for Elm programs";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
