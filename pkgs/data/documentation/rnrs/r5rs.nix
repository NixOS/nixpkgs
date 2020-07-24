{ fetchurl, stdenv, texinfo }:

import ./common.nix {
  inherit fetchurl stdenv texinfo;
  revision = 5;
  sha256 = "1s2wcslwcgb9j89vjn7qs63qlnsv1481jaw1sgg33fgbgk6a8wrk";
}
