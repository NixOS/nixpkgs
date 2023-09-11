{ lib
, fetchFromGitHub
, stdenvNoCC
, mlton
, lua5_3
}:

stdenvNoCC.mkDerivation {
  pname = "lunarml";

  version = "unstable-2023-08-25";

  src = fetchFromGitHub {
    owner = "minoki";
    repo = "LunarML";
    rev = "69d09b47601f4041ca7e8a513c75f3e4835af9dd";
    sha256 = "sha256-GXUcWI4/akOKIvCHrsOfceZEdyNZdIdalTc6wX+svS4=";
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
    homepage = "https://github.com/minoki/LunarML";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ toastal ratsclub ];
    platforms = mlton.meta.platforms;
  };
}
