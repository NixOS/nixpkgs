{ lib
, fetchFromGitHub
, stdenvNoCC
, mlton
, lua5_3
}:

let
  pname = "lunarml";
in
stdenvNoCC.mkDerivation {
  inherit pname;

  version = "unstable-2023-06-25";

  src = fetchFromGitHub {
    owner = "minoki";
    repo = "LunarML";
    rev = "f58f90cf7a2f26340403245907ed183f6a12ab52";
    sha256 = "djHJfUAPplsejFW9L3fbwTeeWgvR+gKkI8TmwIh8n7E=";
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
    mkdir -p $doc/${pname} $out/{bin,lib}
    cp -r bin $out
    cp -r lib $out
    cp -r doc/* README.* LICENSE* $doc/${pname}
    cp -r example $doc/${pname}
  '';

  meta = {
    description = "Standard ML compiler that produces Lua/JavaScript";
    homepage = "https://github.com/minoki/LunarML";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ toastal ];
    platforms = mlton.meta.platforms;
  };
}
