
args: with args;
stdenv.mkDerivation rec {
  name = "ortp-0.13.1";

  src = fetchurl {
    url =
	"http://download.savannah.nongnu.org/releases/linphone/ortp/sources/${name}.tar.gz";
    sha256 = "0k2963v4b15xnf4cpkpgjhsb8ckxpf6vdr8dnw7z3mzilji7391b";
  };

  configureFlags = "--enable-shared --disable-static";

  meta = {
    description = "a Real-Time Transport Protocol (RFC3550) stack under LGPL";
	homepage = http://www.linphone.org/index.php/eng/code_review/ortp;
  };
}
