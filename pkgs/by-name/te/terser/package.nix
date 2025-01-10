{ buildNpmPackage, fetchFromGitHub, lib }:

buildNpmPackage rec {
  pname = "terser";
  version = "5.37.0";

  src = fetchFromGitHub {
    owner = "terser";
    repo = "terser";
    rev = "v${version}";
    hash = "sha256-fLyGcx3Q5Vv7i0d+WA4MIlHnYDc4eBGMCivW32gO+rw=";
  };

  npmDepsHash = "sha256-jM638gdb7BX1nU3sgX68GR4zeywxFgV0hAs9teS+AU8=";

  meta = with lib; {
    description = "JavaScript parser, mangler and compressor toolkit for ES6+";
    mainProgram = "terser";
    homepage = "https://terser.org";
    license = licenses.bsd2;
    maintainers = with maintainers; [ talyz ];
  };
}
