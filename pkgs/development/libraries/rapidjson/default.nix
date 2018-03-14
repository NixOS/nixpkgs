{ stdenv, lib, fetchFromGitHub, pkgconfig, cmake, fetchpatch }:

stdenv.mkDerivation rec {
  name = "rapidjson-${version}";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "Tencent";
    repo = "rapidjson";
    rev = "v${version}";
    sha256 = "1jixgb8w97l9gdh3inihz7avz7i770gy2j2irvvlyrq3wi41f5ab";
  };

  # Fix gcc 7 and later warnings until new release of rapidjson.
  patches = [
    ./disable-implicit-warnings.patch
  ];

  nativeBuildInputs = [ pkgconfig cmake ];

  # detected by gcc7
  NIX_CFLAGS_COMPILE = [ "-Wno-error=implicit-fallthrough" ];

  meta = with lib; {
    description = "Fast JSON parser/generator for C++ with both SAX/DOM style API";
    homepage = "http://rapidjson.org/";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ cstrahan ];
  };
}
