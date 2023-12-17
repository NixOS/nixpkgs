{ buildPythonPackage
, pythonOlder
, fetchPypi
, SDL2
, autoPatchelfHook
, lib
, stdenv
}:

let
  mk-src = sys: hash: {
    platform = "manylinux_2_17_${sys}.manylinux2014_${sys}";
    inherit hash;
  };

  sources = {
    "x86_64-linux" = mk-src "x86_64"
      "sha256-ejxb74E35i/jtye9Xfokk32byJ2kp1Ri4Yf6W6GzKRg=";

    "i686-linux" = mk-src "i686"
      "sha256-g28prnsXPhaR8yw++Ww8QcFF6LpsIrb9KjBKTujY1Dw=";

    "aarch64-linux" = mk-src "aarch64"
      "sha256-kX4UksaIxTvromqG8wU/1vDONuWmaKf32HeYB29hUPQ=";
  };
in
buildPythonPackage rec {
  pname = "pyxel";
  format = "wheel";
  version = "2.0.1";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version format;

    hash = sources.${stdenv.system}.hash;
    python = "cp37";
    dist = "cp37";
    abi = "abi3";
    platform = sources.${stdenv.system}.platform;
  };

  buildInputs = [ SDL2 ];
  nativeBuildInputs = [ autoPatchelfHook ];

  doCheck = false;
  pythonImportsCheck = [ "pyxel" ];

  meta = with lib; {
    homepage = "https://github.com/kitao/pyxel";
    description = "Pyxel is a retro game engine for Python.";
    license = licenses.mit;
    maintainers = with maintainers; [ sigmanificient ];
    changelog = "https://github.com/kitao/pyxel/tree/v${version}/CHANGELOG.md";
    platforms = [ "x86_64-linux" "i686-linux" "aarch64-linux" ];
  };
}
