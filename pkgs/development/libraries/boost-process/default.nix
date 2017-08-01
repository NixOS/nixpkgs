{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation {
  name = "boost-process-0.5";

  src = fetchurl {
    url = "http://www.highscore.de/boost/process0.5/process.zip";
    sha256 = "1v9y9pffb2b7p642kp9ic4z6kg42ziizmyvbgrqd1ci0i4gn0831";
  };

  buildInputs = [ unzip ];

  unpackPhase = ''
    mkdir $name
    cd $name
    unzip $src
  '';

  installPhase = ''
    mkdir -p $out/include
    cp -r boost $out/include
  '';

  meta = with stdenv.lib; {
    homepage = http://www.highscore.de/boost/process0.5/;
    description = "Library to manage system processes";
    license = licenses.boost;
    platforms = platforms.unix;
    maintainers = with maintainers; [ abbradar ];
  };
}
