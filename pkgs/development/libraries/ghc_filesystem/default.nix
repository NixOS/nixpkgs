{ stdenv, lib, cmake, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "filesystem";
  version = "1.5.6";

  src = fetchFromGitHub {
    owner = "gulrak";
    repo = "filesystem";
    rev = "v${version}";
    hash = "sha256-qnBZ9aCrCPOgxymjbzrRs0gssijo8MJOMiy7QWWMb5c=";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "header-only single-file C++ std::filesystem compatible helper library";
    homepage = "https://github.com/gulrak/filesystem";
    license = licenses.mit;
    maintainers = with maintainers; [ lourkeur ];
  };
}
