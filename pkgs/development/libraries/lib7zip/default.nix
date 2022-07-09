{ lib
, stdenv
, fetchFromGitHub
, cmake
, p7zip }:

stdenv.mkDerivation rec {
  pname = "lib7zip";
  version = "unstable-2021-05-26";

  src = fetchFromGitHub {
    owner = "stonewell";
    repo = "lib7zip";
    rev = "53abfeb6f1919fce3e65f21e37340153d2e4fe10";
    sha256 = "sha256-DRnhO+YJjn0qRiPoXgpOv5ujv2knMPSyLxLFPKkziK8=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-DP7ZIP_SOURCE_DIR=${p7zip.src}/"
  ];

  NIX_CFLAGS_COMPILE = [
    "-Wno-error=misleading-indentation"
    "-Wno-error=unused-result"
  ];

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "Small configuration file parser library for C";
    longDescription = ''
      libConfuse (previously libcfg) is a configuration file parser library
      written in C. It supports sections and (lists of) values, as well as
      some other features. It makes it very easy to add configuration file
      capability to a program using a simple API.

      The goal of libConfuse is not to be the configuration file parser library
      with a gazillion of features. Instead, it aims to be easy to use and
      quick to integrate with your code.
    '';
    license = licenses.isc;
    platforms = platforms.linux ++ platforms.darwin;
  };
}
