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
  platforms = {
    aarch64-darwin =
      if pyShortVersion == "cp314" then "macosx_10_15_universal2" else "macosx_10_13_universal2";
    aarch64-linux = "manylinux_2_26_aarch64";
    x86_64-linux = "manylinux2014_x86_64.manylinux_2_17_x86_64";
  };
  platform = platforms.${stdenv.system} or (throw "Unsupported system: ${stdenv.system}");
  hashes = {
    cp313-aarch64-darwin = "sha256-Zcp6DNHl7VfIDmE/NVCcCuqsFUTRdwW3P5pXB9QOJYg=";
    cp313-aarch64-linux = "sha256-OnyM8RjyOB7J+A8ZkNUy6tZ9YfW7wL5Pl3/p6wzW/EE=";
    cp313-x86_64-linux = "sha256-1U6n9B3/NRgCDBpiQPo++PiuMHcEC04eRF/mmiOemMo=";
    cp314-aarch64-darwin = "sha256-RtVy4e9eOdrPu6JjqTPL4S/6dWgQWz5D7YE1NH2GYi4=";
    cp314-aarch64-linux = "sha256-9woHRqVAX3sLO2kYilaWIcIoyQ9t/6JiGeR7gtyPTok=";
    cp314-x86_64-linux = "sha256-wuh9n7Upf6JgpiZmpn8p2L6TkCeQXNo1PKG2IEchLog=";
  };
  hash =
    hashes."${pyShortVersion}-${stdenv.system}"
      or (throw "Unsupported Python version: ${python.pythonVersion}");
in
buildPythonPackage rec {
  pname = "gurobipy";
  version = "13.0.3";
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
