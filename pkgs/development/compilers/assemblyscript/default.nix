{ lib
, buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "assemblyscript";
  version = "0.27.22";

  src = fetchFromGitHub {
    owner = "AssemblyScript";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-8j012eAM+tl8AH5vNhg9xKDRJt5pZKV9KNwJFmUgXMY=";
  };

  npmDepsHash = "sha256-y7gY9VhbR+xfXf3OvKvpcohk2mwfa0uOQO7Nmg+L6ug=";

  meta = with lib; {
    homepage = "https://github.com/AssemblyScript/${pname}";
    description = "A TypeScript-like language for WebAssembly";
    license = licenses.asl20;
    maintainers = with maintainers; [ lucperkins ];
  };
}
