{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "luau";
  version = "0.570";

  src = fetchFromGitHub {
    owner = "Roblox";
    repo = "luau";
    rev = version;
    hash = "sha256-22T/NweWrDNWmGKJIk/htHUSU2htwsJ+0tHw5AtfoOo=";
  };

  nativeBuildInputs = [ cmake ];

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
    homepage = "https://luau-lang.org/";
    description = "A fast, small, safe, gradually typed embeddable scripting language derived from Lua";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [ maintainers.marsam ];
  };
}
