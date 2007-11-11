args: with args;

stdenv.mkDerivation {
  name = "speex-1.2beta2";
  src = fetchurl {
    url = http://downloads.us.xiph.org/releases/speex/speex-1.2beta2.tar.gz;
	sha256 = "1np34q5i7yswkgknb8pa6ngqb4l4jv84c9yqnn0215vncbl76xg5";
  };
  buildInputs = [libogg];
}
