{
  lib,
  autoPatchelfHook,
  buildPythonPackage,
  fetchPypi,
  python,
  stdenv,
  zlib,
}:
assert python.implementation == "cpython";

let
  interpreter = "cp${builtins.replaceStrings [ "." ] [ "" ] python.pythonVersion}";
  abi = builtins.elemAt python.pythonABITags 2;
  inherit (stdenv.hostPlatform) system;
  releases = lib.importJSON ./releases.json;
in
buildPythonPackage rec {
  pname = "saxonche";
  inherit (releases) version;
  format = "wheel";

  src = fetchPypi {
    pname = "saxonche";
    inherit version abi;
    format = "wheel";
    python = interpreter;
    dist = interpreter;
    platform = releases."${interpreter}-${abi}-${system}".platform or (throw "unsupported system");
    hash = releases."${interpreter}-${abi}-${system}".hash or (throw "unsupported system");
  };

  dontBuild = true;

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

  buildInputs = [
    zlib
  ];

  pythonImportsCheck = [ "saxonche" ];

  passthru.updateScript = ./update.py;

  meta = {
    description = "Official Python package for the SaxonC-HE processor";
    homepage = "https://www.saxonica.com/saxon-c/index.xml";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ hhr2020 ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
