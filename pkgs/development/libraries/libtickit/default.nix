{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, libtool
, perl
, libtermkey
, unibilium
}:
let
  version = "0.4.3";
in
stdenv.mkDerivation {
  pname = "libtickit";
  inherit version;

  src = fetchFromGitHub {
    owner = "leonerd";
    repo = "libtickit";
    rev = "v${version}";
    hash = "sha256-QCrym8g5J1qwsFpU/PB8zZIWdM3YzOySknISSbQE4Sc=";
  };

  patches = [
    # Disabled on darwin, since test assumes TERM=linux
    ./001-skip-test-18term-builder-on-macos.patch
  ];

  nativeBuildInputs = [
    pkg-config
    libtool
  ];

  buildInputs = [
    libtermkey
    unibilium
  ];

  nativeCheckInputs = [ perl ];

  makeFlags = [
    "LIBTOOL=${lib.getExe libtool}"
  ];

  installFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  enableParallelBuilding = true;

  doCheck = true;

  meta = with lib; {
    description = "Terminal interface construction kit";
    longDescription = ''
      This library provides an abstracted mechanism for building interactive full-screen terminal
      programs. It provides a full set of output drawing functions, and handles keyboard and mouse
      input events.
    '';
    homepage = "https://www.leonerd.org.uk/code/libtickit/";
    license = licenses.mit;
    maintainers = with maintainers; [ onemoresuza ];
    platforms = platforms.unix;
  };
}
