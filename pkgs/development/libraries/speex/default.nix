args: with args;

stdenv.mkDerivation {
  name = "speex-1.2beta3";
  src = fetchurl {
    url = http://downloads.us.xiph.org/releases/speex/speex-1.2beta3.tar.gz;
	sha256 = "1az7kiwa8mzi1x7j01gcakx854qcbm4g67n0c4s56bvny6dn18vp";
  };
  buildInputs = [libogg];
}
