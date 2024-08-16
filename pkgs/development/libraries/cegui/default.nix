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
  version = "0-unstable-2023-03-18";

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
    # The above branch is separate from the branch with the latest tags, so the updater doesn't pick them up
    # This is what would be used to handle upstream's format, if it was able to see the tags
    # tagConverter = writeShellScript "cegui-tag-converter.sh" ''
    #   sed -e 's/^v//g' -e 's/-/./g'
    # '';
    hardcodeZeroVersion = true;
  };

  meta = with lib; {
    homepage = "http://cegui.org.uk/";
    description = "C++ Library for creating GUIs";
    mainProgram = "CEGUISampleFramework-0.9999";
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
