{ lib, stdenv, fetchzip, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "libpgf";
  version = "7.21.2";

  src = fetchzip {
    url = "mirror://sourceforge/${pname}/${pname}/${version}/${pname}.zip";
    sha256 = "0l1j5b1d02jn27miggihlppx656i0pc70cn6x89j1rpj33zn0g9r";
  };

  nativeBuildInputs = [ autoreconfHook ];

  autoreconfPhase = ''
    mv README.txt README
    sh autogen.sh
  '';

  meta = {
    homepage = "https://www.libpgf.org/";
    description = "Progressive Graphics Format";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
  };
}
