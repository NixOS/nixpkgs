{ lib, stdenv, fetchFromGitHub, cmake, fmt_8, fetchpatch }:

let
  generic = { version, sha256, patches ? [] }:
    stdenv.mkDerivation {
      pname = "spdlog";
      inherit version;

      src = fetchFromGitHub {
        owner  = "gabime";
        repo   = "spdlog";
        rev    = "v${version}";
        inherit sha256;
      };

      inherit patches;

      nativeBuildInputs = [ cmake ];
      # spdlog <1.3 uses a bundled version of fmt
      propagatedBuildInputs = lib.optional (lib.versionAtLeast version "1.3") fmt_8;

      cmakeFlags = [
        "-DSPDLOG_BUILD_SHARED=${if stdenv.hostPlatform.isStatic then "OFF" else "ON"}"
        "-DSPDLOG_BUILD_STATIC=${if stdenv.hostPlatform.isStatic then "ON" else "OFF"}"
        "-DSPDLOG_BUILD_EXAMPLE=OFF"
        "-DSPDLOG_BUILD_BENCH=OFF"
        "-DSPDLOG_BUILD_TESTS=ON"
        "-DSPDLOG_FMT_EXTERNAL=ON"
      ];

      outputs = [ "out" "doc" ]
        # spdlog <1.4 is header only, no need to split libraries and headers
        ++ lib.optional (lib.versionAtLeast version "1.4") "dev";

      postInstall = ''
        mkdir -p $out/share/doc/spdlog
        cp -rv ../example $out/share/doc/spdlog
      '';

      doCheck = true;
      preCheck = "export LD_LIBRARY_PATH=$(pwd)\${LD_LIBRARY_PATH:+:}$LD_LIBRARY_PATH";

      meta = with lib; {
        description    = "Very fast, header only, C++ logging library";
        homepage       = "https://github.com/gabime/spdlog";
        license        = licenses.mit;
        maintainers    = with maintainers; [ obadz ];
        platforms      = platforms.all;
      };
    };
in
{
  spdlog_1 = generic {
    version = "1.9.2";
    sha256 = "sha256-GSUdHtvV/97RyDKy8i+ticnSlQCubGGWHg4Oo+YAr8Y=";
    patches = [
      # glibc 2.34 compat
      (fetchpatch {
        url = "https://github.com/gabime/spdlog/commit/d54b8e89c058f3cab2b32b3e9a2b49fd171d5895.patch";
        sha256 = "sha256-pb7cREF90GXb5Mbs8xFLQ+eLo6Xum13/xYa8JUgJlbI=";
      })
    ];
  };

  spdlog_0 = generic {
    version = "0.17.0";
    sha256 = "112kfh4fbpm5cvrmgbgz4d8s802db91mhyjpg7cwhlywffnzkwr9";
  };
}
