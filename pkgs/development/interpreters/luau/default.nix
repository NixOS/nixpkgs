{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "luau";
  version = "0.552";

  src = fetchFromGitHub {
    owner = "Roblox";
    repo = "luau";
    rev = version;
    sha256 = "sha256-dxxzM9VKN4yDkVpU3uQNgiFbBXBa+ALWSG/Ut6JKOEY=";
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
