args : with args; 
rec {
  src = fetchurl {
    url = http://ftp.de.debian.org/debian/pool/main/l/lmodern/lmodern_1.010x.orig.tar.gz;
    sha256 = "0nwxj1ng7rvnp16jxcs25hbc5in65mdk4a3g3rlaq91i5qpq7mxj";
  };

  buildInputs = [];
  configureFlags = [];

  /* doConfigure should be specified separately */
  phaseNames = ["doCopy"];

  doCopy = FullDepEntry(''
    ensureDir $out/share/texmf/
    ensureDir $out/share/fonts/

    cp -r ./* $out/share/texmf/
    cp -r fonts/{opentype,type1} $out/share/fonts/
  '') ["minInit" "defEnsureDir" "doUnpack"];

  name = "lmodern-" + version;
  meta = {
    description = "Latin Modern font";
  };
}

