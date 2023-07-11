{ lib, stdenv, fetchurl, fetchpatch, pkg-config, json_c, hidapi }:

stdenv.mkDerivation rec {
  pname = "libu2f-host";
  version = "1.1.10";

  src = fetchurl {
    url = "https://developers.yubico.com/${pname}/Releases/${pname}-${version}.tar.xz";
    sha256 = "0vrivl1dwql6nfi48z6dy56fwy2z13d7abgahgrs2mcmqng7hra2";
  };

  patches = [
    # remove after updating to next release
    (fetchpatch {
      name = "json-c-0.14-support.patch";
      url = "https://github.com/Yubico/libu2f-host/commit/840f01135d2892f45e71b9e90405de587991bd03.patch";
      sha256 = "0xplx394ppsbsb4h4l8b9m4dv9shbl0zyck3y26vbm9i1g981ki7";
    })
  ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ json_c hidapi ];

  doCheck = true;

  meta = with lib; {
    description = "A C library and command-line tool that implements the host-side of the U2F protocol";
    homepage = "https://developers.yubico.com/libu2f-host";
    license = with licenses; [ gpl3Plus lgpl21Plus ];
    mainProgram = "u2f-host";
    platforms = platforms.unix;
  };
}
