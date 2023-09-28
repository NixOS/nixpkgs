{ stdenv
, lib
, fetchurl
, aspell
, groff
, pkg-config
, glib
, hunspell
, hspell
, nuspell
, unittest-cpp
}:

stdenv.mkDerivation rec {
  pname = "enchant";
  version = "2.6.1";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "https://github.com/AbiWord/${pname}/releases/download/v${version}/${pname}-${version}.tar.gz";
    hash = "sha256-8k4SRpE3rh0DFAu5AypHpZR8NvTR4vErkpBhAF6xUnk=";
  };

  nativeBuildInputs = [
    groff
    pkg-config
  ];

  buildInputs = [
    glib
    hunspell
    nuspell
  ];

  nativeCheckInputs = [
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
    "--with-aspell"
    "--with-hspell"
    "--with-hunspell"
    "--with-nuspell"
  ];

  meta = with lib; {
    description = "Generic spell checking library";
    homepage = "https://abiword.github.io/enchant/";
    license = licenses.lgpl21Plus; # with extra provision for non-free checkers
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.unix;
  };
}
