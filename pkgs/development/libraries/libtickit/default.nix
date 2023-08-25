{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, libtool
, perl
, libtermkey
, unibilium
}:
stdenv.mkDerivation rec {
  pname = "libtickit";
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "leonerd";
    repo = "libtickit";
    rev = "v${version}";
    hash = "sha256-QCrym8g5J1qwsFpU/PB8zZIWdM3YzOySknISSbQE4Sc=";
  };

  makeFlags = [
    "PREFIX=$(out)"
    "LIBTOOL=${lib.getExe libtool}"
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

  patches = [
    ./skipTestMacOS.patch
  ];

  doCheck = true;

  meta = with lib; {
    description = "A terminal interface construction kit";
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
