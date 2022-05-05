{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "luau";
  version = "0.525";

  src = fetchFromGitHub {
    owner = "roblox";
    repo = "luau";
    rev = version;
    sha256 = "sha256-6317vVWfih3YRj/dINhA74F5Fiu/p06an46yGFYZ7Qg=";
  };

  nativeBuildInputs = [ cmake ];

  installPhase = ''
    install -Dm755 luau $out/bin/luau
    install -Dm755 luau-analyze $out/bin/luau-analyze
  '';

  doCheck = true;
  checkPhase = ''
    ./Luau.UnitTest && ./Luau.Conformance
  '';

  meta = {
    homepage = "https://luau-lang.org";
    description = "A fast, small, safe, gradually typed embeddable scripting language derived from Lua";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.basicer ];
  };
}
