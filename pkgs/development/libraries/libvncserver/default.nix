{ stdenv, fetchzip, fetchpatch, cmake
, libjpeg, openssl, zlib, libgcrypt, libpng
, systemd
}:

let
  s = # Generated upstream information
  rec {
    pname = "libvncserver";
    version = "0.9.12";
    url = "https://github.com/LibVNC/libvncserver/archive/LibVNCServer-${version}.tar.gz";
    sha256 = "1226hb179l914919f5nm2mlf8rhaarqbf48aa649p4rwmghyx9vm"; # unpacked archive checksum
  };
in
stdenv.mkDerivation {
  inherit (s) pname version;
  src = fetchzip {
    inherit (s) url sha256;
  };
  patches = [
    (fetchpatch {
      name = "CVE-2018-20750.patch";
      url = "https://github.com/LibVNC/libvncserver/commit/09e8fc02f59f16e2583b34fe1a270c238bd9ffec.patch";
      sha256 = "004h50786nvjl3y3yazpsi2b767vc9gqrwm1ralj3zgy47kwfhqm";
    })
    (fetchpatch {
      name = "CVE-2019-15681.patch";
      url = "https://github.com/LibVNC/libvncserver/commit/d01e1bb4246323ba6fcee3b82ef1faa9b1dac82a.patch";
      sha256 = "0hf0ss7all2m50z2kan4mck51ws44yim4ymn8p0d991y465y6l9s";
    })
  ];
  nativeBuildInputs = [ cmake ];
  buildInputs = [
    libjpeg openssl libgcrypt libpng
  ] ++ stdenv.lib.optional stdenv.isLinux systemd;
  propagatedBuildInputs = [ zlib ];
  meta = {
    inherit (s) version;
    description = "VNC server library";
    homepage = "https://libvnc.github.io/";
    license = stdenv.lib.licenses.gpl2Plus ;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.unix;
  };
}
