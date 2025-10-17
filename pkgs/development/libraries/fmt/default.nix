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
      hash,
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
        inherit hash;
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
        maintainers = [ ];
        license = licenses.mit;
        platforms = platforms.all;
      };
    };
in
{
  fmt_9 = generic {
    version = "9.1.0";
    hash = "sha256-rP6ymyRc7LnKxUXwPpzhHOQvpJkpnRFOt2ctvUNlYI0=";
    patches = [
      # Fixes the build with Clang ≥ 18.
      (fetchpatch {
        url = "https://github.com/fmtlib/fmt/commit/c4283ec471bd3efdb114bc1ab30c7c7c5e5e0ee0.patch";
        hash = "sha256-YyB5GY/ZqJQIhhGy0ICMPzfP/OUuyLnciiyv8Nscsec=";
      })
    ];
  };

  fmt_10 = generic {
    version = "10.2.1";
    hash = "sha256-pEltGLAHLZ3xypD/Ur4dWPWJ9BGVXwqQyKcDWVmC3co=";
  };

  fmt_11 = generic {
    version = "11.2.0";
    hash = "sha256-sAlU5L/olxQUYcv8euVYWTTB8TrVeQgXLHtXy8IMEnU=";
    patches = [
      # Fixes the build with libc++ ≥ 21.
      (fetchpatch {
        url = "https://github.com/fmtlib/fmt/commit/3cabf3757b6bc00330b55975317b2c145e4c689d.patch";
        hash = "sha256-SJFzNNC0Bt2aEQJlHGc0nv9KOpPQ+TgDX5iuFMUs9tk=";
      })
    ];
  };
}
