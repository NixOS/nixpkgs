{ lib, stdenv, fetchurl, libiconv }:

stdenv.mkDerivation rec {
  pname = "htmlcxx";
  version = "0.86";

  src = fetchurl {
    url = "mirror://sourceforge/htmlcxx/htmlcxx/${version}/${pname}-${version}.tar.gz";
    sha256 = "1hgmyiad3qgbpf2dvv2jygzj6jpz4dl3n8ds4nql68a4l9g2nm07";
  };

  buildInputs = [ libiconv ];
  patches = [ ./ptrdiff.patch ];

  meta = with lib; {
    homepage = "http://htmlcxx.sourceforge.net/";
    description = "A simple non-validating css1 and html parser for C++";
    license = licenses.lgpl2;
    platforms = platforms.all;
  };
}
