{ lib, stdenv, fetchFromGitHub, cmake, fmt_8
, staticBuild ? stdenv.hostPlatform.isStatic
}:

let
  generic = { version, sha256 }:
    stdenv.mkDerivation {
      pname = "spdlog";
      inherit version;

      src = fetchFromGitHub {
        owner  = "gabime";
        repo   = "spdlog";
        rev    = "v${version}";
        inherit sha256;
      };

      nativeBuildInputs = [ cmake ];
      # spdlog <1.3 uses a bundled version of fmt
      propagatedBuildInputs = lib.optional (lib.versionAtLeast version "1.3") fmt_8;

      cmakeFlags = [
        "-DSPDLOG_BUILD_SHARED=${lib.boolToCMakeString (!staticBuild)}"
        "-DSPDLOG_BUILD_STATIC=${lib.boolToCMakeString staticBuild}"
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
    version = "1.10.0";
    sha256 = "sha256-c6s27lQCXKx6S1FhZ/LiKh14GnXMhZtD1doltU4Avws=";
  };

  spdlog_0 = generic {
    version = "0.17.0";
    sha256 = "112kfh4fbpm5cvrmgbgz4d8s802db91mhyjpg7cwhlywffnzkwr9";
  };
}
