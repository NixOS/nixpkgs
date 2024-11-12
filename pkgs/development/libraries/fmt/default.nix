{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  enableShared ? !stdenv.hostPlatform.isStatic,

  # tests
  mpd,
  openimageio,
  fcitx5,
  spdlog,
}:

let
  generic =
    {
      version,
      sha256,
      patches ? [ ],
    }:
    stdenv.mkDerivation {
      pname = "fmt";
      inherit version;

      outputs = [
        "out"
        "dev"
      ];

      src = fetchFromGitHub {
        owner = "fmtlib";
        repo = "fmt";
        rev = version;
        inherit sha256;
      };

      inherit patches;

      nativeBuildInputs = [ cmake ];

      cmakeFlags = [ (lib.cmakeBool "BUILD_SHARED_LIBS" enableShared) ];

      doCheck = true;

      passthru.tests = {
        inherit
          mpd
          openimageio
          fcitx5
          spdlog
          ;
      };

      meta = with lib; {
        description = "Small, safe and fast formatting library";
        longDescription = ''
          fmt (formerly cppformat) is an open-source formatting library. It can be
          used as a fast and safe alternative to printf and IOStreams.
        '';
        homepage = "https://fmt.dev/";
        changelog = "https://github.com/fmtlib/fmt/blob/${version}/ChangeLog.rst";
        downloadPage = "https://github.com/fmtlib/fmt/";
        maintainers = [ maintainers.jdehaas ];
        license = licenses.mit;
        platforms = platforms.all;
      };
    };
in
{
  fmt_9 = generic {
    version = "9.1.0";
    sha256 = "sha256-rP6ymyRc7LnKxUXwPpzhHOQvpJkpnRFOt2ctvUNlYI0=";
  };

  fmt_10 = generic {
    version = "10.2.1";
    sha256 = "sha256-pEltGLAHLZ3xypD/Ur4dWPWJ9BGVXwqQyKcDWVmC3co=";
  };

  fmt_11 = generic {
    version = "11.0.2";
    sha256 = "sha256-IKNt4xUoVi750zBti5iJJcCk3zivTt7nU12RIf8pM+0=";
    patches = [
      (fetchpatch {
        name = "get-rid-of-std-copy-fix-clang.patch";
        url = "https://github.com/fmtlib/fmt/commit/6e462b89aa22fd5f737ed162d0150e145ccb1914.patch";
        hash = "sha256-tRU1y1VCxtQ5J2yvFmwUx+YNcQs8izzLImD37KBiCFk=";
      })
    ];
  };
}
