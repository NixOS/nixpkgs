{ lib, stdenv, fetchurl, readline, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "mujs";
  version = "1.2.0";

  src = fetchurl {
    url = "https://mujs.com/downloads/mujs-${version}.tar.xz";
    sha256 = "sha256-ZpdtHgajUnVKI0Kvc9Guy7U8x82uK2jNoBO33c+SMjM=";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2022-44789.patch";
      url = "https://git.ghostscript.com/?p=mujs.git;a=patch;h=edb50ad66f7601ca9a3544a0e9045e8a8c60561f";
      sha256 = "sha256-KHBJlDchrXTmN5vEuyQ+saX12F5hyUlJFguiDsZkGqc=";
    })
    (fetchpatch {
      name = "regex-compilation-stack-overflow.patch";
      url = "https://git.ghostscript.com/?p=mujs.git;a=patch;h=160ae29578054dc09fd91e5401ef040d52797e61";
      sha256 = "sha256-R0gTPj10fKtHbVe5RM6HNL772hVl9rXylkPw5qQWt0w=";
    })
  ];

  buildInputs = [ readline ];

  makeFlags = [ "prefix=$(out)" ];

  meta = with lib; {
    homepage = "https://mujs.com/";
    description = "A lightweight, embeddable Javascript interpreter";
    platforms = platforms.unix;
    maintainers = with maintainers; [ pSub ];
    license = licenses.isc;
  };
}
