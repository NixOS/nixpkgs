{ stdenv
, fetchurl
, aspell
, pkgconfig
, glib
, hunspell
, hspell
, unittest-cpp
}:

stdenv.mkDerivation rec {
  pname = "enchant";
  version = "2.2.10";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "https://github.com/AbiWord/${pname}/releases/download/v${version}/${pname}-${version}.tar.gz";
    sha256 = "1hxx5kb015a5rvjimrpcb5050xb3988dgc52fd5m5n270v238nva";
  };

  nativeBuildInputs = [
    pkgconfig
  ];

  buildInputs = [
    glib
    hunspell
  ];

  checkInputs = [
    unittest-cpp
  ];

  # libtool puts these to .la files
  propagatedBuildInputs = [
    hspell
    aspell
  ];

  enableParallelBuilding = true;

  doCheck = true;

  configureFlags = [
    "--enable-relocatable" # needed for tests
  ];

  meta = with stdenv.lib; {
    description = "Generic spell checking library";
    homepage = "https://abiword.github.io/enchant/";
    license = licenses.lgpl21Plus; # with extra provision for non-free checkers
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.unix;
  };
}
