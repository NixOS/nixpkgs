{ lib, stdenv, fetchFromGitHub, cmake, gitUpdater, llvmPackages }:

stdenv.mkDerivation rec {
  pname = "luau";
  version = "0.621";

  src = fetchFromGitHub {
    owner = "luau-lang";
    repo = "luau";
    rev = version;
    hash = "sha256-bkuYYGYcnMwQDK81ZH+74hA4XaQfVFMWvAKpy+ODCak=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = lib.optionals stdenv.cc.isClang [ llvmPackages.libunwind ];

  installPhase = ''
    runHook preInstall

    install -Dm755 -t $out/bin luau
    install -Dm755 -t $out/bin luau-analyze
    install -Dm755 -t $out/bin luau-compile

    runHook postInstall
  '';

  doCheck = true;

  checkPhase = ''
    runHook preCheck

    ./Luau.UnitTest
    ./Luau.Conformance

    runHook postCheck
  '';

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    description = "A fast, small, safe, gradually typed embeddable scripting language derived from Lua";
    homepage = "https://luau-lang.org/";
    changelog = "https://github.com/luau-lang/luau/releases/tag/${version}";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [ ];
    mainProgram = "luau";
  };
}
