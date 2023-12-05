{ lib
, buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "assemblyscript";
  version = "0.27.9";

  src = fetchFromGitHub {
    owner = "AssemblyScript";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-UOMWUM1wOhX2pR29DSYpPKLnjb1CWrKk6BtyXK7kqDk=";
  };

  npmDepsHash = "sha256-9ILa1qY2GpP2RckcZYcCMmgCwdXIImOm+D8nldeoQL8=";

  meta = with lib; {
    homepage = "https://github.com/AssemblyScript/${pname}";
    description = "A TypeScript-like language for WebAssembly";
    license = licenses.asl20;
    maintainers = with maintainers; [ lucperkins ];
  };
}
