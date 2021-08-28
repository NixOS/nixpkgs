{ stdenv, lib, cmake, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "filesystem";
  version = "1.5.4";

  src = fetchFromGitHub {
    owner = "gulrak";
    repo = "filesystem";
    rev = "v${version}";
    hash = "sha256-SvNUzKoNiSIM0no+A0NUT6hmeUH9SzgLQLrC5XOC0Ho=";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "header-only single-file C++ std::filesystem compatible helper library";
    homepage = "https://github.com/gulrak/filesystem";
    license = licenses.mit;
    maintainers = with maintainers; [ lourkeur ];
  };
}
