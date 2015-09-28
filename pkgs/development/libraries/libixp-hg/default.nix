{ stdenv, fetchhg, txt2tags }:

stdenv.mkDerivation rec {
  rev = "148";
  version = "hg-2012-12-02";
  name = "libixp-${version}";

  src = fetchhg {
    url = https://code.google.com/p/libixp/;
    sha256 = "1nbnh2ff18fsrs28mx4bfgncq1d1nw5dd6iwhwvv5x2g9w7q5vvj";
    inherit rev;
  };

  configurePhase = ''
   sed -i -e "s|^PREFIX.*=.*$|PREFIX = $out|" config.mk
  '';

  buildInputs = [ txt2tags ];

  meta = {
    homepage = https://code.google.com/p/libixp/;
    description = "Portable, simple C-language 9P client and server libary";
    maintainers = with stdenv.lib.maintainers; [ kovirobi ];
    license = stdenv.lib.licenses.mit;
    inherit version;
  };
}
