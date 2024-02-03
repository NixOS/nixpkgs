{ lib, git, clang,
  fetchFromGitHub, requireFile,
  openssl, xz, gnutar,
  automake, autoconf, libtool, clangStdenv } :

clangStdenv.mkDerivation rec {
  pname = "ios-cross-compile";
  version = "9.2";
  sdk = "iPhoneOS9.2.sdk";
  cctools_port = fetchFromGitHub {
    owner = "tpoechtrager";
    repo = "cctools-port";
    rev = "7d405492b09fa27546caaa989b8493829365deab";
    sha256 = "0nj1q5bqdx5jm68dispybxc7wnkb6p8p2igpnap9q6qyv2r9p07w";
  };
  ldid = fetchFromGitHub {
    owner = "tpoechtrager";
    repo = "ldid";
    rev = "3064ed628108da4b9a52cfbe5d4c1a5817811400";
    sha256 = "1a6zaz8fgbi239l5zqx9xi3hsrv3jmfh8dkiy5gmnjs6v4gcf6sf";
  };
  src = requireFile rec {
    name = "iPhoneOS9.2.sdk.tar.xz";
    sha256 = "1l2h3cic9psrq3nmfv9aaxkdk8y2pvr0iq6apj87mb3ms9a4cqrq";
    message = ''
      You need to do the following steps to get a prepared
      ios tarball.

      1) Download an XCode dmg, specifically XCode_7.2.dmg
      2) Install darling-dmg, available via: nix-env -i darling-dmg
      3) Follow this shell history:

      $ cd ~/
      $ mkdir xcode
      $ darling-dmg Xcode_7.2dmg xcode
      $ cd xcode/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs
      $ mktemp -d
        /tmp/gar/tmp.4ZZ8kqyfqp/
      $ mkdir /tmp/gar/tmp.4ZZ8kqyfqp/iPhoneOS9.2.sdk
      $ cp -r iPhoneOS.sdk/* /tmp/gar/tmp.4ZZ8kqyfqp/iPhoneOS9.2.sdk
      $ cp -r ../../../../Toolchains/XcodeDefault.xctoolchain/usr/include/c++/* \
        /tmp/gar/tmp.4ZZ8kqyfqp/iPhoneOS9.2.sdk/usr/include/c++
      $ tar -cf - * | xz -9 -c - > iPhoneOS9.2.sdk.tar.xz
      $ cd ~/
      $ fusermount -u xcode

      Then do:

      nix-prefetch-url file:///path/to/${name}

      and run this installation again.
   '';
  };
  nativeBuildInputs = [ autoconf automake ];
  buildInputs = [ git xz gnutar openssl libtool clang ];
  alt_wrapper = ./alt_wrapper.c;
  builder = ./9.2_builder.sh;
  meta = {
    description =
    "Provides an iOS cross compiler from 7.1 up to iOS-${version} and ldid";
    platforms = lib.platforms.linux;
    hydraPlatforms = [];
    maintainers = with lib.maintainers; [ fxfactorial ];
    license = lib.licenses.gpl2;
  };
}
