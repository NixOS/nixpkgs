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
<<<<<<< HEAD
  version = "2.5.0";
=======
  version = "2.3.4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "https://github.com/AbiWord/${pname}/releases/download/v${version}/${pname}-${version}.tar.gz";
<<<<<<< HEAD
    sha256 = "sha256-FJ4iTN0sqCXYdGOVeLYkbgfzfVuPOXBlijd6HvRvLhU=";
=======
    sha256 = "sha256-H34mdE2xyaD+ph0hafTlwc5DXPjCcxw34+QFQRnplKA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
