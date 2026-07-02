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
      if pyShortVersion == "cp314" then "macosx_10_15_universal2" else "macosx_10_13_universal2";
    aarch64-linux = "manylinux_2_26_aarch64";
    x86_64-darwin = aarch64-darwin;
    x86_64-linux = "manylinux2014_x86_64.manylinux_2_17_x86_64";
  };
  platform = platforms.${stdenv.system} or (throw "Unsupported system: ${stdenv.system}");
  hashes = rec {
    cp312-aarch64-darwin = "sha256-ZLZmYCOPV7da3Jdh+YFSQ3PzLOjN039L8vKNwbaZ0dU=";
    cp312-aarch64-linux = "sha256-c/jZOsTZwZb9e1g2qDUC1Bpu0M5yvCetXC6REyQx9+s=";
    cp312-x86_64-darwin = cp312-aarch64-darwin;
    cp312-x86_64-linux = "sha256-815AT8MpIalMvFsEfgGtcUztI7oMHd+BteWiC/U9dXo=";
    cp313-aarch64-darwin = "sha256-bMS+dXVA9Is/IGQnysvNePXowH3d2GVOOxxuO4cycII=";
    cp313-aarch64-linux = "sha256-QH+HuHtVay1z9zjKS5pBw67Q7kEpWKaLEn0hCKjDAOI=";
    cp313-x86_64-darwin = cp313-aarch64-darwin;
    cp313-x86_64-linux = "sha256-HXhA/feSim+vn/95Xd5yeUAWTofQvO2YB13x6tOLEvk=";
    cp314-aarch64-darwin = "sha256-qCfv866Sa2diUCa4A2UAere+OY5g4Yh1MmjcHw6Haz4=";
    cp314-aarch64-linux = "sha256-93FNadd4r4gtdW4iI0CSDo2/wASlCZmGBMubTLHUMkI=";
    cp314-x86_64-darwin = cp314-aarch64-darwin;
    cp314-x86_64-linux = "sha256-+CNAcIlVwkqyD11BtNf70OlM9Od0CEE2DiAkydIilh8=";
  };
  hash =
    hashes."${pyShortVersion}-${stdenv.system}"
      or (throw "Unsupported Python version: ${python.pythonVersion}");
in
buildPythonPackage rec {
  pname = "gurobipy";
  version = "13.0.2";
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
