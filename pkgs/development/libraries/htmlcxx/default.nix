{ lib, stdenv, fetchurl, libiconv }:

stdenv.mkDerivation rec {
  pname = "htmlcxx";
  version = "0.87";

  src = fetchurl {
    url = "mirror://sourceforge/htmlcxx/v${version}/${pname}-${version}.tar.gz";
    sha256 = "sha256-XTj5OM9N+aKYpTRq8nGV//q/759GD8KgIjPLz6j8dcg=";
  };

  buildInputs = [ libiconv ];
  patches = [
    ./ptrdiff.patch
    ./c++17.patch
  ];

  meta = with lib; {
    homepage = "http://htmlcxx.sourceforge.net/";
    description = "A simple non-validating css1 and html parser for C++";
    license = licenses.lgpl2;
    platforms = platforms.all;
  };
}
