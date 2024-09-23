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
    cp311-aarch64-darwin = "sha256-E4tL6PtC1JS4SEvUz6meoeUR6IYM2xFxNJ9PzgbZqgE=";
    cp311-aarch64-linux = "sha256-hMWOFkyQ/B3ovAqsitJagrSp0webUGRzWCLOz1UrGyY=";
    cp311-x86_64-darwin = cp311-aarch64-darwin;
    cp311-x86_64-linux = "sha256-2O7Vykgx0fELCM1wH3VIOyeBBzR1DUFKWzy25LpMF/M=";
    cp312-aarch64-darwin = "sha256-BXAJeUaVEa7fy00BNsFhB30IU5O2pEnJjp/3gYdHJ5w=";
    cp312-aarch64-linux = "sha256-t1KopNiYo8xZsGcKpEne6OIVnU9CDzADO6+W8Uo2UW0=";
    cp312-x86_64-darwin = cp312-aarch64-darwin;
    cp312-x86_64-linux = "sha256-0IppqYhLLHq4Q8mWe0R3DBfHOsVybbeoeUroXXwfxEY=";
  };
  hash =
    hashes."${pyShortVersion}-${stdenv.system}"
      or (throw "Unsupported Python version: ${python.pythonVersion}");
in
buildPythonPackage rec {
  pname = "gurobipy";
  version = "11.0.3";
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
