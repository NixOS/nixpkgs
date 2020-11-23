{ stdenv, fetchFromGitHub, fetchpatch, cmake, enableShared ? true }:

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
        "-DCMAKE_SKIP_BUILD_RPATH=OFF" # for tests
      ];

      doCheck = true;

      meta = with stdenv.lib; {
        description = "Small, safe and fast formatting library";
        longDescription = ''
          fmt (formerly cppformat) is an open-source formatting library. It can be
          used as a fast and safe alternative to printf and IOStreams.
        '';
        homepage = "http://fmtlib.net/";
        downloadPage = "https://github.com/fmtlib/fmt/";
        maintainers = [ maintainers.jdehaas ];
        license = licenses.bsd2;
        platforms = platforms.all;
      };
    };
in
{
  fmt_7 = generic {
    version = "7.1.2";
    sha256 = "1ixwkqdbm01rcmqni15z4jj2rzhb3w7nlhkw2w4dzc4m101vr6yz";
  };
}
