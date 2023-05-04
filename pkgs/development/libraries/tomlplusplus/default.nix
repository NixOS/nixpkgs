{ lib
, stdenv
, buildPackages
, cmake
, ninja
, fetchFromGitHub
, fetchpatch
}:

# Fix regression in precomputing CMAKE_SIZEOF_VOID_P
# See https://github.com/mesonbuild/meson/pull/11761
let fixedMeson =
      buildPackages.meson.overrideAttrs (
        {patches ? [], ...}: {
          patches = patches ++ [
            (fetchpatch {
              url = "https://github.com/mesonbuild/meson/commit/7c78c2b5a0314078bdabb998ead56925dc8b0fc0.patch";
              sha256 = "sha256-vSnHhuOIXf/1X+bUkUmGND5b30ES0O8EDArwb4p2/w4=";
            })
          ];
        }
      ); in

stdenv.mkDerivation rec {
  pname = "tomlplusplus";
  version = "3.3.0";

  src = fetchFromGitHub {
    owner = "marzer";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-INX8TOEumz4B5coSxhiV7opc3rYJuQXT2k1BJ3Aje1M=";
  };

  nativeBuildInputs = [ fixedMeson cmake ninja ];

  meta = with lib;{
    homepage = "https://github.com/marzer/tomlplusplus";
    description = "Header-only TOML config file parser and serializer for C++17";
    license = licenses.mit;
    maintainers = with maintainers; [ Scrumplex ];
    platforms = with platforms; unix;
  };
}
