{
  stdenv,
  lib,
  cmake,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "filesystem";
  version = "1.5.12";

  src = fetchFromGitHub {
    owner = "gulrak";
    repo = "filesystem";
    rev = "v${version}";
    hash = "sha256-j4RE5Ach7C7Kef4+H9AHSXa2L8OVyJljDwBduKcC4eE=";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "header-only single-file C++ std::filesystem compatible helper library";
    homepage = "https://github.com/gulrak/filesystem";
    license = licenses.mit;
    maintainers = with maintainers; [ bbjubjub ];
  };
}
