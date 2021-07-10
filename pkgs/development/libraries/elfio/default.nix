{ stdenv, lib, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "elfio";
  version = "3.8";

  src = fetchFromGitHub {
    owner = "serge1";
    repo = "ELFIO";
    rev = "Release_${version}";
    sha256 = "1h6q4nf19wpgzrz0wycl60s200r642jv41k1ffmqncgf92qy4yyv";
  };

  installPhase = ''
      mkdir -p $out/include
      cp -R ./elfio $out/include
  '';

  meta = with lib; {
    description = "Small, header-only C++ library that provides a simple interface for reading and generating files in ELF binary format";
    homepage = "https://serge1.github.io/ELFIO";
    license = licenses.mit;
    maintainers = [ teams.deshaw.members ];
  };
}
