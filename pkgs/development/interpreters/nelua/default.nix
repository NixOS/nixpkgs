{ lib, stdenv, fetchFromGitHub, luaPackages }:

stdenv.mkDerivation {
  pname = "nelua";
  version = "unstable-2023-09-16";

  src = fetchFromGitHub {
    owner = "edubart";
    repo = "nelua-lang";
    rev = "596fcca5c77932da8a07c249de59a9dff3099495";
    hash = "sha256-gXTlAxW7s3VBiC1fGU0aUlGspHlvyY7FC5KLeU2FyGQ=";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  nativeCheckInputs = [ luaPackages.luacheck ];

  doCheck = true;

  meta = with lib; {
    description = "Minimal, efficient, statically-typed and meta-programmable systems programming language heavily inspired by Lua, which compiles to C and native code";
    homepage = "https://nelua.io/";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [ maintainers.marsam ];
  };
}
