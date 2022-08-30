{ stdenv, lib
, fetchurl
, autoPatchelfHook
, gmp5, ncurses5, zlib
}:

stdenv.mkDerivation rec {
  pname = "lamdera";
  version = "1.0.1";

  src = fetchurl {
    url = "https://static.lamdera.com/bin/linux/lamdera-v${version}";
    sha256 = "15dee9df5d4e71b07a65fbd89d0f7dcd8c3e7ba05fe2b0e7a30d29bbd1239d9f";
  };

  dontUnpack = true;

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    gmp5
    ncurses5
    zlib
  ];


  installPhase = ''
    install -m755 -D $src $out/bin/lamdera
  '';

  meta = with lib; {
    homepage = https://lamdera.com;
    license = licenses.unfree;
    description = "A delightful platform for full-stack web apps";
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ Zimmi48 ];
  };
}
