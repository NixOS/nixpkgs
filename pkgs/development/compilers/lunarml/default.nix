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

  version = "unstable-2023-07-25";

  src = fetchFromGitHub {
    owner = "minoki";
    repo = "LunarML";
    rev = "4a5f9c7d42c6b1fcd3d73ab878321f887a153aa7";
    sha256 = "dpYUXMbYPRvk+t6Cnc4uh8w5MwuPXuKPgZQl2P0EBZU=";
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
