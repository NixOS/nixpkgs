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
    cp311-aarch64-darwin = "sha256-KRC3fY7KUVCfI4u+TQQjgqLLIEunkzgIZxiuTol2/50=";
    cp311-aarch64-linux = "sha256-/DiS49iND4oB2nXxL3QCPTmO9Zmp4a3WbtdjE3M+MPs=";
    cp311-x86_64-darwin = cp311-aarch64-darwin;
    cp311-x86_64-linux = "sha256-oI+0Kl58sCzbmTwTgci4xaO67tyt1W5yiNhFile4FEI=";
    cp312-aarch64-darwin = "sha256-tcNcuYGmFScBaFUyTgVMrkc0lnhdtX8Ggr1W1YSpbu4=";
    cp312-aarch64-linux = "sha256-+Ch951NcO5yX9KqHFpadcDAqlyvQnp07b71yZsoOq3I=";
    cp312-x86_64-darwin = cp312-aarch64-darwin;
    cp312-x86_64-linux = "sha256-kLukle+yXP9aOCYViv974pY30ugKzMOompjLhjCFYQY=";
  };
  hash =
    hashes."${pyShortVersion}-${stdenv.system}"
      or (throw "Unsupported Python version: ${python.pythonVersion}");
in
buildPythonPackage rec {
  pname = "gurobipy";
  version = "12.0.0";
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
