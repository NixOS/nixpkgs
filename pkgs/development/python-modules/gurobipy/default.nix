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
    aarch64-linux = "manylinux2014_aarch64.manylinux_2_17_aarch64";
    x86_64-darwin = aarch64-darwin;
    x86_64-linux = "manylinux2014_x86_64.manylinux_2_17_x86_64";
  };
  platform = platforms.${stdenv.system} or (throw "Unsupported system: ${stdenv.system}");
  hashes = rec {
    cp311-aarch64-darwin = "sha256-jODaasqXupII5JDE1QLUK+Jd07WJfAtxB3NIHCeuDa4=";
    cp311-aarch64-linux = "sha256-hx6BgCbI8ojXRA/NS4Qr7N8QBvQ0lfxPbj7G2bi6PXo=";
    cp311-x86_64-darwin = cp311-aarch64-darwin;
    cp311-x86_64-linux = "sha256-hiZbepqPPlMcG77m5hwefQtoJk6XZ5W0z3rsaLnmbrg=";
    cp312-aarch64-darwin = "sha256-H5J44n2CUqOo8jzn2G6gZPehWsbPnZtHXi4Iygx2RRM=";
    cp312-aarch64-linux = "sha256-xFUR7yizqSsytyfStRigKlZ7q8uY+VgRR/j29DKPWp0=";
    cp312-x86_64-darwin = cp312-aarch64-darwin;
    cp312-x86_64-linux = "sha256-giNHTNfLX1hIiWOPQlLOnqjrbPWkKQrA4KXug6ujYxI=";
  };
  hash =
    hashes."${pyShortVersion}-${stdenv.system}"
      or (throw "Unsupported Python version: ${python.pythonVersion}");
in
buildPythonPackage rec {
  pname = "gurobipy";
  version = "11.0.2";
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
