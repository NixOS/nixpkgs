<<<<<<< HEAD
{ lib, stdenv, fetchurl, openssl, libidn, glib, pkg-config, zlib, darwin }:
=======
{ lib, stdenv, fetchurl, openssl, libidn, glib, pkg-config, zlib }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

stdenv.mkDerivation rec {
  version = "1.5.3";
  pname = "loudmouth";

  src = fetchurl {
    url = "https://mcabber.com/files/loudmouth/${pname}-${version}.tar.bz2";
    sha256 = "0b6kd5gpndl9nzis3n6hcl0ldz74bnbiypqgqa1vgb0vrcar8cjl";
  };

<<<<<<< HEAD
=======
  patches = [
  ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  configureFlags = [ "--with-ssl=openssl" ];

  propagatedBuildInputs = [ openssl libidn glib zlib ];

  nativeBuildInputs = [ pkg-config ];

<<<<<<< HEAD
  buildInputs = lib.optionals (stdenv.isDarwin && lib.versionOlder stdenv.hostPlatform.darwinMinVersion "11") [
    darwin.apple_sdk.frameworks.AppKit
    darwin.apple_sdk.frameworks.Foundation
  ];

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "A lightweight C library for the Jabber protocol";
    platforms = platforms.all;
    downloadPage = "http://mcabber.com/files/loudmouth/";
    license = licenses.lgpl21;
  };
}
