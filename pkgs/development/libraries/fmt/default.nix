{ lib
, stdenv
, fetchFromGitHub
, cmake
, enableShared ? !stdenv.hostPlatform.isStatic

# tests
, mpd
, openimageio
, fcitx5
, spdlog
}:

let
  generic = { version, sha256, patches ? [ ] }:
    stdenv.mkDerivation {
      pname = "fmt";
      inherit version;

      outputs = [ "out" "dev" ];

      src = fetchFromGitHub {
        owner = "fmtlib";
        repo = "fmt";
        rev = version;
        inherit sha256;
      };

      inherit patches;

      nativeBuildInputs = [ cmake ];

      cmakeFlags = [
        "-DBUILD_SHARED_LIBS=${if enableShared then "ON" else "OFF"}"
      ];

      doCheck = true;

      passthru.tests = {
        inherit mpd openimageio fcitx5 spdlog;
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
  fmt_8 = generic {
    version = "8.1.1";
    sha256 = "sha256-leb2800CwdZMJRWF5b1Y9ocK0jXpOX/nwo95icDf308=";
  };

  fmt_9 = generic {
    version = "9.1.0";
    sha256 = "sha256-rP6ymyRc7LnKxUXwPpzhHOQvpJkpnRFOt2ctvUNlYI0=";
  };

  fmt_10 = generic {
    version = "10.0.0";
    sha256 = "sha256-sVY2TVPS/Zx32p5XIYR6ghqN4kOZexzH7Cr+y8sZXK8=";
  };
}
