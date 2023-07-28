{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation {
  pname = "spirv-headers";
  version = "unstable-2023-07-21";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "SPIRV-Headers";
    rev = "51b106461707f46d962554efe1bf56dee28958a3";
    hash = "sha256-b+GA2Wo+kgxZWqaqjwSuvScxux5SzHYh8OsXe/3MmUk=";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "Machine-readable components of the Khronos SPIR-V Registry";
    homepage = "https://github.com/KhronosGroup/SPIRV-Headers";
    license = licenses.mit;
    maintainers = [ maintainers.ralith ];
  };
}
