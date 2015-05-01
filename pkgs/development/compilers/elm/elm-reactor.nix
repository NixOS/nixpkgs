{ unzip, fetchurl, fetchFromGitHub, cabal, blazeHtml, blazeMarkup, cmdargs, elmCompiler, elmMake, filepath
, fsnotify, HTTP, mtl, snapCore, snapServer, systemFilepath, text
, time, transformers, unorderedContainers, websockets
, websocketsSnap
}:

cabal.mkDerivation (self: rec {
  pname = "elm-reactor";
  version = "0.3.1";
  isLibrary = false;
  isExecutable = true;
  buildTools = [ unzip ];

  src = fetchFromGitHub {
    owner = "elm-lang";
	repo = "elm-reactor";
	rev = "ec35c68d075cf1a6712cd3c01fc343deb6b897bd";
	sha256 = "0wbnxradp9bidca6vhp7hqhc22nxhs9im74v0crgpi67pysk7nn5";
  };
  elmLangCore = fetchurl {
    url = "https://github.com/elm-lang/core/archive/2.0.0.zip";
    sha256 = "1h1zbsmav25lbkdbm3zrc1n7ad04b7nhc4qqdnjps17f44rsc828";
  };
  elmHtml = fetchurl {
	url = "https://github.com/evancz/elm-html/archive/3.0.0.zip";
    sha256 = "0yysaqn6bxk13bggmdimkb3jx28k2hkrnii8wfhjhlf3khz9m7kg";
  };
  elmMarkdown = fetchurl {
	url = "https://github.com/evancz/elm-markdown/archive/1.1.4.zip";
	sha256 = "0az1a2z7yndpx1jijlnw1k2zslq4b2wy7q2z4rlvxy99m4mygxjm";
  };
  virtualDom = fetchurl {
	url = "https://github.com/evancz/virtual-dom/archive/1.2.3.zip";
	sha256 = "07zkr5pk7925lhmzllnnzp1vda6k2iildwd8m404m4sfz6zyr7qp";
  };

  elmStuff = ./elm-reactor-exact-dependencies.json;

  preConfigure = ''
	unzip -d $TEMPDIR -q ${elmLangCore}
	mkdir -p elm-stuff/packages/elm-lang/core/2.0.0
	cp -pr $TEMPDIR/core-2.0.0/* elm-stuff/packages/elm-lang/core/2.0.0/

	unzip -d $TEMPDIR -q ${elmHtml}
	mkdir -p elm-stuff/packages/evancz/elm-html/3.0.0
	cp -pr $TEMPDIR/elm-html-3.0.0/* elm-stuff/packages/evancz/elm-html/3.0.0

	unzip -d $TEMPDIR -q ${elmMarkdown}
	mkdir -p elm-stuff/packages/evancz/elm-markdown/1.1.4
	cp -pr $TEMPDIR/elm-markdown-1.1.4/* elm-stuff/packages/evancz/elm-markdown/1.1.4

	unzip -d $TEMPDIR -q ${virtualDom}
	mkdir -p elm-stuff/packages/evancz/virtual-dom/1.2.3
	cp -pr $TEMPDIR/virtual-dom-1.2.3/* elm-stuff/packages/evancz/virtual-dom/1.2.3

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
