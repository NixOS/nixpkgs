{ lib
, buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "assemblyscript";
  version = "0.27.6";

  src = fetchFromGitHub {
    owner = "AssemblyScript";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-jN8P3EL3giDIZSExkjm5ZUwgkN3EIQhVpMqfx273yZU=";
  };

  npmDepsHash = "sha256-9ILa1qY2GpP2RckcZYcCMmgCwdXIImOm+D8nldeoQL8=";

  meta = with lib; {
    homepage = "https://github.com/AssemblyScript/${pname}";
    description = "A TypeScript-like language for WebAssembly";
    license = licenses.asl20;
    maintainers = with maintainers; [ lucperkins ];
  };
}
