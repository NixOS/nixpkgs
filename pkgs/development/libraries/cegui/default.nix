<<<<<<< HEAD
{ lib
, stdenv
, fetchFromGitHub
, cmake
, ogre
, freetype
, boost
, expat
, darwin
, libiconv
, unstableGitUpdater
}:

stdenv.mkDerivation {
  pname = "cegui";
  version = "unstable-2023-03-18";

  src = fetchFromGitHub {
    owner = "paroj";
    repo = "cegui";
    rev = "186ce900e293b98f2721c11930248a8de54aa338";
    hash = "sha256-RJ4MnxklcuxC+ZYEbfma5RDc2aeJ95LuTwNk+FnEhdo=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    ogre
    freetype
    boost
    expat
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Cocoa
    darwin.apple_sdk.frameworks.Foundation
    libiconv
  ];

  cmakeFlags = [
    "-DCEGUI_OPTION_DEFAULT_IMAGECODEC=OgreRenderer-0"
  ] ++ lib.optionals (stdenv.hostPlatform.isDarwin) [
    "-DCMAKE_OSX_ARCHITECTURES=${stdenv.hostPlatform.darwinArch}"
  ];

  passthru.updateScript = unstableGitUpdater {
    branch = "v0";
  };
=======
{ lib, stdenv, fetchurl, cmake, ogre, freetype, boost, expat, libiconv }:

stdenv.mkDerivation rec {
  pname = "cegui";
  version = "0.8.7";

  src = fetchurl {
    url = "mirror://sourceforge/crayzedsgui/${pname}-${version}.tar.bz2";
    sha256 = "067562s71kfsnbp2zb2bmq8zj3jk96g5a4rcc5qc3n8nfyayhldk";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ ogre freetype boost expat ]
    ++ lib.optionals stdenv.isDarwin [ libiconv ];

  cmakeFlags = lib.optional (stdenv.isDarwin && stdenv.isAarch64) "-DCMAKE_OSX_ARCHITECTURES=arm64";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    homepage = "http://cegui.org.uk/";
    description = "C++ Library for creating GUIs";
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
