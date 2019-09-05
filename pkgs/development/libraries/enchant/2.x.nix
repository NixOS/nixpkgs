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
  version = "2.2.5";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "https://github.com/AbiWord/${pname}/releases/download/v${version}/${pname}-${version}.tar.gz";
    sha256 = "0r41qjz3104h5raiwlw5ywwybafbxdjz12j1bnq3kq60jlr6d2pf";
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
    homepage = https://abiword.github.io/enchant/;
    license = licenses.lgpl21Plus; # with extra provision for non-free checkers
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.unix;
  };
}
