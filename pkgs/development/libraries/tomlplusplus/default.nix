{ lib
, stdenv
, meson
, ninja
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "tomlplusplus";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "marzer";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-nohO4eySs73BSgjvq+uzybiE5lw2rFY5YqGbl/oqGek=";
  };

  nativeBuildInputs = [ meson ninja ];

  meta = with lib;{
    homepage = "https://github.com/marzer/tomlplusplus";
    description = "Header-only TOML config file parser and serializer for C++17";
    license = licenses.mit;
    maintainers = with maintainers; [ Scrumplex ];
    platforms = with platforms; unix;
  };
}
