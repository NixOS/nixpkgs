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
    cp312-aarch64-darwin = "sha256-ZCrGAEiKZ/u/gmVmEanbVJPXDmzglk4ZHER6ZBBsMlw=";
    cp312-aarch64-linux = "sha256-Rf8dzgH3hbL7XPfqYtqQSkSSC7JulID7/t8dL2fawa4=";
    cp312-x86_64-darwin = cp312-aarch64-darwin;
    cp312-x86_64-linux = "sha256-42xX3wMwxCdylNCQVlpWxWoIPYPXDDCvjpxETYCoVKU=";
    cp313-aarch64-darwin = "sha256-ykkK56TacwNhszVkNQqUwK1gXL9wvnMwcbHHtSJmU1U=";
    cp313-aarch64-linux = "sha256-yXHkDdzhdR4HfhYFk+0412pz0pg2X9P5BzfBVDEEQk0=";
    cp313-x86_64-darwin = cp313-aarch64-darwin;
    cp313-x86_64-linux = "sha256-bgB87cLGn1oXkY0P406I6V8WcLXCSsgooN8rFxY0NFk=";
  };
  hash =
    hashes."${pyShortVersion}-${stdenv.system}"
      or (throw "Unsupported Python version: ${python.pythonVersion}");
in
buildPythonPackage rec {
  pname = "gurobipy";
  version = "12.0.1";
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
