{ stdenv, lib, fetchurl, makeWrapper, coreutils }:

stdenv.mkDerivation rec {
  pname = "taskspooler";
  version = "1.0.1";

  src = fetchurl {
    url = "https://vicerveza.homeunix.net/%7Eviric/wsgi-bin/hgweb.wsgi/ts/archive/7cf9a8bda6d3.tar.gz";
    sha256 = "11i21s8sdmjl4gy5f3dyfsxsmg1japgs4r5ym0b3jdyp99xhpbl1";
  };

  nativeBuildInputs = [ makeWrapper ];

  postPatch = ''
    substituteInPlace Makefile \
      --replace "PREFIX?=/usr/local" "PREFIX=$out"
  '';

  postFixup = ''
    wrapProgram $out/bin/ts \
      --set-default TS_SLOTS "$(${coreutils}/bin/nproc --all)"
  '';

  meta = with lib; {
    description = "Simple single node task scheduler";
    homepage = "https://vicerveza.homeunix.net/~viric/wsgi-bin/hgweb.wsgi/ts";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.sheepforce ];
    mainProgram = "ts";
    platforms = platforms.unix;
  };
}
