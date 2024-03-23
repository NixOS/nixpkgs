{
  lib,
  stdenv,
  buildPythonPackage,
  python,
  fetchPypi,
}:

let
  format = "wheel";
  pyShortVersion = "cp" + builtins.replaceStrings [ "." ] [ "" ] python.pythonVersion;
  platforms = rec {
    aarch64-darwin = "macosx_10_9_universal2";
    x86_64-darwin = aarch64-darwin;
  };
  platform = platforms.${stdenv.system} or (throw "Unsupported system: ${stdenv.system}");
  hashes = rec {
    cp311-aarch64-darwin = "sha256-pMwq4TXvr0mrKxZppeW2MQE/KrplWWFGmjKRLKwbHCI=";
    cp311-x86_64-darwin = cp311-aarch64-darwin;
    cp312-aarch64-darwin = "sha256-5+1QxYOhjbs01S3gqhkQ9Bx/0/NhbXEi710BGpiC5kM=";
    cp312-x86_64-darwin = cp312-aarch64-darwin;
  };
  hash =
    hashes."${pyShortVersion}-${stdenv.system}"
      or (throw "Unsupported Python version: ${python.pythonVersion}");
in
buildPythonPackage rec {
  pname = "gurobipy";
  version = "11.0.1";
  inherit format;

  src = fetchPypi {
    inherit pname version;
    python = pyShortVersion;
    abi = pyShortVersion;
    dist = pyShortVersion;
    inherit format platform hash;
  };

  pythonImportsCheck = [ "gurobipy" ];

  meta = {
    description = "Python interface to Gurobi";
    homepage = "https://www.gurobi.com";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ wegank ];
    platforms = builtins.attrNames platforms;
  };
}
