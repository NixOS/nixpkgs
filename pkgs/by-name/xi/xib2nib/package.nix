{
  lib,
  stdenv,
  fetchFromGitHub,
  boost,
  plistcpp,
  pugixml,
}:

stdenv.mkDerivation {
  pname = "xib2nib";
  version = "0-unstable-2017-04-12";

  src = fetchFromGitHub {
    owner = "matthewbauer";
    repo = "xib2nib";
    rev = "97c6a53aab83d919805efcae33cf80690e953d1e";
    hash = "sha256-GMf/XQYYCzuX1rcU3l7bTxhGlCnZliHtZCqf14kThCA=";
  };

  buildInputs = [
    boost
    plistcpp
    pugixml
  ];

  makeFlags = [
    "PREFIX=$(out)"
  ];

  meta = with lib; {
    maintainers = with maintainers; [ matthewbauer ];
    description = "Compiles CocoaTouch .xib files into .nib";
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
