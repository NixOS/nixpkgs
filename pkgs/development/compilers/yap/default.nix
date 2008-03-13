args:
args.stdenv.mkDerivation rec {
  name = "Yap-5.1.1";

  src = args.fetchurl {
    url = "http://downloads.sourceforge.net/yap/${name}.tar.gz";
    sha256 = "0bajxmlla9gay4m4l7y7x6qldxzi0jcq2ykgpjk9liky7g5kbnya";
  };

  buildInputs =(with args; []);

  meta = { 
      description = "Yap Prolog System is a ISO-compatible high-performance Prolog compiler";
      homepage = http://yap.sourceforge.net/;
      license = "artistic";
  };
}
