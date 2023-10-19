{ lib
, fetchFromGitHub
, stdenvNoCC
, mlton
, lua5_3
}:

stdenvNoCC.mkDerivation {
  pname = "lunarml";

  version = "unstable-2023-09-21";

  src = fetchFromGitHub {
    owner = "minoki";
    repo = "LunarML";
    rev = "c6e23ae68149bda550ddb75c0df9f422aa379b3a";
    sha256 = "DY4gOCXfGV1OVdGXd6GGvbHlQdWWxMg5TZzkceeOu9o=";
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
