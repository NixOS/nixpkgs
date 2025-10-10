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
    aarch64-darwin =
      if pyShortVersion == "cp313" then "macosx_10_13_universal2" else "macosx_10_9_universal2";
    aarch64-linux = "manylinux2014_aarch64.manylinux_2_17_aarch64";
    x86_64-darwin = aarch64-darwin;
    x86_64-linux = "manylinux2014_x86_64.manylinux_2_17_x86_64";
  };
  platform = platforms.${stdenv.system} or (throw "Unsupported system: ${stdenv.system}");
  hashes = rec {
    cp312-aarch64-darwin = "sha256-Ag8jJ39jDgeerBFDheq9G9n7SsIvh5btW6bZFc5PFBs=";
    cp312-aarch64-linux = "sha256-crv1RLwFBgu5OQm3lxWs5MD0FhmPdiKphcq7no6Zqhw=";
    cp312-x86_64-darwin = cp312-aarch64-darwin;
    cp312-x86_64-linux = "sha256-s/lxyvJw9nG2/89bk3s8BDClJksPAVKdyGgdYcIh8hU=";
    cp313-aarch64-darwin = "sha256-qFUuR2c8tvH9NR7fj8rYawL4Msv7V9kO8h4Dl+ltE44=";
    cp313-aarch64-linux = "sha256-vgXAdBQcihJsiq7MxBeVqwkaZm6rs5yh/5inS96B5mM=";
    cp313-x86_64-darwin = cp313-aarch64-darwin;
    cp313-x86_64-linux = "sha256-eaMzdm4n/veQLO7vvPAnmhyjk6J6cupi+OMBshqhfVk=";
  };
  hash =
    hashes."${pyShortVersion}-${stdenv.system}"
      or (throw "Unsupported Python version: ${python.pythonVersion}");
in
buildPythonPackage rec {
  pname = "gurobipy";
  version = "12.0.3";
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
