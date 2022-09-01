{ lib, stdenv, fetchFromGitHub, fetchpatch, cmake
, enableShared ? !stdenv.hostPlatform.isStatic
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
        "-DBUILD_SHARED_LIBS=${lib.boolToCMakeString enableShared}"
      ];

      doCheck = true;

      meta = with lib; {
        description = "Small, safe and fast formatting library";
        longDescription = ''
          fmt (formerly cppformat) is an open-source formatting library. It can be
          used as a fast and safe alternative to printf and IOStreams.
        '';
        homepage = "http://fmtlib.net/";
        downloadPage = "https://github.com/fmtlib/fmt/";
        maintainers = [ maintainers.jdehaas ];
        license = licenses.mit;
        platforms = platforms.all;
      };
    };
in
{
  fmt_7 = generic {
    version = "7.1.3";
    sha256 = "08hyv73qp2ndbs0isk8pspsphdzz5qh8czl3wgyxy3mmif9xdg29";
  };

  fmt_8 = generic {
    version = "8.1.1";
    sha256 = "sha256-leb2800CwdZMJRWF5b1Y9ocK0jXpOX/nwo95icDf308=";
  };
}
