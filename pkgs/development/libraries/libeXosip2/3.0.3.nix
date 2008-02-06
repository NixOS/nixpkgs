args: with args;

stdenv.mkDerivation rec {
  name = "libeXosip2-" + version;

  src = fetchurl {
    url = "http://downloa.savannah.nongnu.org/releases/exosip/${name}.tar.gz";
    sha256 = "0jgy2mjq7r4kp8afl8zhymvca6hghp6chv36laiqz4bizcddzvxa";
  };

  propagatedBuildInputs = [libosip2];
  configureFlags = "--enable-shared --disable-static";
}
