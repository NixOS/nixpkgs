{ stdenv
, lib
, fetchurl
, fetchpatch
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
  version = "2.6.2";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "https://github.com/AbiWord/${pname}/releases/download/v${version}/${pname}-${version}.tar.gz";
    hash = "sha256-ZoanKOVudg+N7gmiLw+1O0bunb59ZM+eW7NaZYv/fh0=";
  };

  patches = [
    # fix build with clang 16
    (fetchpatch {
      url = "https://github.com/AbiWord/enchant/commit/f71eb22e4af7f9917011807a41cf295d3ce0ccbc.patch";
      hash = "sha256-9WWvpU3HKzPlxNBYQAKPppW6G3kOIC2A+MqX5eheBDA=";
    })
  ];

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
