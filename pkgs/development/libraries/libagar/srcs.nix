{ fetchurl }:
rec {
  version = "1.5.0";

  src = fetchurl {
    url = "http://stable.hypertriton.com/agar/agar-${version}.tar.gz";
    sha256 = "001wcqk5z67qg0raw9zlwmv62drxiwqykvsbk10q2mrc6knjsd42";
  };

}
