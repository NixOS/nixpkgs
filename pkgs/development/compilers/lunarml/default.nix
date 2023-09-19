{ lib
, fetchFromGitHub
, stdenvNoCC
, mlton
, lua5_3
}:

stdenvNoCC.mkDerivation {
  pname = "lunarml";

  version = "unstable-2023-09-16";

  src = fetchFromGitHub {
    owner = "minoki";
    repo = "LunarML";
    rev = "0fe97ebed71d6aa24c9e80436d45af1b3ef6abd3";
    sha256 = "KSLQva4Lv+hZWrx2cMbLOj82ldodiGn/9j8ksB1FN+s=";
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
