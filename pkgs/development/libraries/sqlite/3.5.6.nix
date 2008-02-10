args: with args;

stdenv.mkDerivation rec {
  name = "sqlite-" + version;

  src = fetchurl {
    url = "${meta.homepage}/${name}.tar.gz";
    sha256 = "1fz82x3wp2h1g701w8qrsg58hc0jmrhw2593crx0c663iqhvjwqn";
  };

  configureFlags = "--enable-shared --disable-static";

  propagatedBuildInputs = [readline];

  meta = {
    homepage = http://www.sqlite.org;
  };
}
