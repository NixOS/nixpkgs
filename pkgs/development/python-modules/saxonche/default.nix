{
  lib,
  autoPatchelfHook,
  buildPythonPackage,
  fetchPypi,
  python,
  stdenv,
  zlib,
}:
let
  pythonVersionNoDot = builtins.replaceStrings [ "." ] [ "" ] python.pythonVersion;
  inherit (stdenv.hostPlatform) system;
  releases = lib.importJSON ./releases.json;
in
buildPythonPackage rec {
  pname = "saxonche";
  inherit (releases) version;
  format = "wheel";

  src = fetchPypi {
    pname = "saxonche";
    inherit version;
    format = "wheel";
    python = "cp${pythonVersionNoDot}";
    abi = "cp${pythonVersionNoDot}";
    dist = "cp${pythonVersionNoDot}";
    platform = releases."cp${pythonVersionNoDot}-${system}".platform or (throw "unsupported system");
    hash = releases."cp${pythonVersionNoDot}-${system}".hash or (throw "unsupported system");
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
