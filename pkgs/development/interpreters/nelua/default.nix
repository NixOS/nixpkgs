{ lib, stdenv, fetchFromGitHub, luaPackages }:

stdenv.mkDerivation {
  pname = "nelua";
  version = "unstable-2022-11-20";

  src = fetchFromGitHub {
    owner = "edubart";
    repo = "nelua-lang";
    rev = "63909dc834708a5bd7c21d65a6633880f40295db";
    hash = "sha256-GeknXYsdRUzihzF3qHcCgbcB3w8geiWe5O1Az+4UqMs=";
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
