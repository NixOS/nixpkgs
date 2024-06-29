{ lib
, fetchFromGitHub
, stdenvNoCC
, mlton
, lua5_3
}:

let
  version = "0.1.0";
in
stdenvNoCC.mkDerivation {
  inherit version;

  pname = "lunarml";

  src = fetchFromGitHub {
    owner = "minoki";
    repo = "LunarML";
    rev = "refs/tags/v${version}";
    hash = "sha256-wM6ppH0g8yIi+4fwTejzZGn1uv/Wvlajn87A+IKbPXw=";
  };

  outputs = [ "out" "doc" ];

  nativeBuildInputs = [
    mlton
  ];

  nativeCheckInputs = [
    lua5_3
  ];

  postBuild = ''
    make -C thirdparty install
  '';

  doCheck = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $doc/lunarml $out/{bin,lib}
    cp -r bin $out
    cp -r lib $out
    cp -r example $doc/lunarml

    runHook postInstall
  '';

  meta = {
    description = "Standard ML compiler that produces Lua/JavaScript";
    mainProgram = "lunarml";
    homepage = "https://github.com/minoki/LunarML";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ toastal ratsclub ];
    platforms = mlton.meta.platforms;
  };
}
