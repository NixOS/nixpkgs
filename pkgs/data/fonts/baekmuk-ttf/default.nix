{ lib, mkFont, fetchzip }:

mkFont rec {
  pname = "baekmuk-ttf";
  version = "2.2";

  src = fetchzip {
    url = "https://kldp.net/baekmuk/release/865-${pname}-${version}.tar.gz";
    sha256 = "126zkgsrphgxqjwi0km4l8g9lnjvv233ikbp870bpkxnf6wgrwwm";
  };

  meta = with lib; {
    description = "Korean font";
    homepage = "https://kldp.net/projects/baekmuk/";
    license = licenses.free; # BSD-like
  };
}

