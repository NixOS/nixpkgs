{ lib, stdenv, fetchurl, autoreconfHook, pkg-config, libzen, zlib, fetchpatch }:

stdenv.mkDerivation rec {
  version = "21.09";
  pname = "libmediainfo";
  src = fetchurl {
    url =
      "https://mediaarea.net/download/source/libmediainfo/${version}/libmediainfo_${version}.tar.xz";
    sha256 = "09pinxqw3z3hxrafn67clw1cb1z9aqfy6gkiavginfm0yr299gk9";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ libzen zlib ];

  patches = [
    # fixes pkgsMusl.libmediainfo build
    (fetchpatch {
      url =
        "https://git.alpinelinux.org/aports/plain/community/libmediainfo/fix-include-signal.patch?id=b8d666a3d33575c184308e1176f4de9e519af577";
      sha256 = "sha256-b3HoIwy/hKSh8jUakwVJpnPmYw5KUwZXgLW7IPMY4/c=";
    })
  ];

  postPatch = "cd Project/GNU/Library";

  configureFlags = [ "--enable-shared" ];

  enableParallelBuilding = true;

  postInstall = ''
    install -vD -m 644 libmediainfo.pc "$out/lib/pkgconfig/libmediainfo.pc"
  '';

  meta = with lib; {
    description = "Shared library for mediainfo";
    homepage = "https://mediaarea.net/";
    license = licenses.bsd2;
    platforms = platforms.unix;
    maintainers = [ maintainers.devhell ];
  };
}
