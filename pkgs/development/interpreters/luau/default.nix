{ lib, stdenv, fetchFromGitHub, cmake, llvmPackages }:

stdenv.mkDerivation rec {
  pname = "luau";
  version = "0.598";

  src = fetchFromGitHub {
    owner = "Roblox";
    repo = "luau";
    rev = version;
    hash = "sha256-B3ggPrhvq1kYmclmuomi6PhXIwN8GKBzbKRLIjH0pac=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = lib.optionals stdenv.cc.isClang [ llvmPackages.libunwind ];

  installPhase = ''
    runHook preInstall

    install -Dm755 -t $out/bin luau
    install -Dm755 -t $out/bin luau-analyze

    runHook postInstall
  '';

  doCheck = true;

  checkPhase = ''
    runHook preCheck

    ./Luau.UnitTest
    ./Luau.Conformance

    runHook postCheck
  '';

  meta = with lib; {
    description = "A fast, small, safe, gradually typed embeddable scripting language derived from Lua";
    homepage = "https://luau-lang.org/";
    changelog = "https://github.com/Roblox/luau/releases/tag/${version}";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [ maintainers.marsam ];
  };
}
