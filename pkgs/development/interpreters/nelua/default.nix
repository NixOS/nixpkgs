{ lib, stdenv, fetchFromGitHub, luaPackages }:

stdenv.mkDerivation {
  pname = "nelua";
  version = "unstable-2023-01-21";

  src = fetchFromGitHub {
    owner = "edubart";
    repo = "nelua-lang";
    rev = "d10cc61bc54050b07874a8597f8df20534885105";
    hash = "sha256-HyNYqhPCQVBJqEcAUUXfvycXE8tWIMIUJJMTIV48ne8=";
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
