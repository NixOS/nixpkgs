{
  lib,
  stdenv,
  fetchurl,
  unzip,
}:

stdenv.mkDerivation rec {
  pname = "boost-process";
  version = "0.5";

  src = fetchurl {
    url = "http://www.highscore.de/boost/process${version}/process.zip";
    sha256 = "1v9y9pffb2b7p642kp9ic4z6kg42ziizmyvbgrqd1ci0i4gn0831";
  };

  nativeBuildInputs = [ unzip ];

  unpackPhase = ''
    mkdir boost-process-$version
    cd boost-process-$version
    unzip $src
  '';

  installPhase = ''
    mkdir -p $out/include
    cp -r boost $out/include
  '';

  meta = with lib; {
    homepage = "http://www.highscore.de/boost/process0.5/";
    description = "Library to manage system processes";
    license = licenses.boost;
    platforms = platforms.unix;
    maintainers = with maintainers; [ abbradar ];
  };
}
