{ fetchurl, stdenv, texinfo }:

import ./common.nix {
  inherit fetchurl stdenv texinfo;
  revision = 4;
  sha256 = "02jgy0lvi5ymkdxwjasg50zl03zmyj8sgnfxxnjnbmif72c0k4p8";
}
