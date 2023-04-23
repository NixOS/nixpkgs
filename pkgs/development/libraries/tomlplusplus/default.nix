{ lib
, stdenv
, meson
, cmake
, ninja
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "tomlplusplus";
  version = "3.3.0";

  src = fetchFromGitHub {
    owner = "marzer";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-INX8TOEumz4B5coSxhiV7opc3rYJuQXT2k1BJ3Aje1M=";
  };

  nativeBuildInputs = [ meson cmake ninja ];

  meta = with lib;{
    homepage = "https://github.com/marzer/tomlplusplus";
    description = "Header-only TOML config file parser and serializer for C++17";
    license = licenses.mit;
    maintainers = with maintainers; [ Scrumplex ];
    platforms = with platforms; unix;
  };
}
