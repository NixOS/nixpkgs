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
    cp312-aarch64-darwin = "sha256-hQ9VN5Wl8RQ53ShE5q/LqzgNsZHX27W7b05rGeH95jc=";
    cp312-aarch64-linux = "sha256-wKQjIAmhM+Smk3XzzlR8ZtwxJpr8hvbV15QTfSMxuE8=";
    cp312-x86_64-darwin = cp312-aarch64-darwin;
    cp312-x86_64-linux = "sha256-yISDKQFJYKZAxXE2vyrcanXcc3FvUHKcpshtaLnwtrI=";
    cp313-aarch64-darwin = "sha256-j8E8zsPr1m4q7p1i4ihUuzPSczbRKuZGWp0C/oNx0Lc=";
    cp313-aarch64-linux = "sha256-QvHfssbnKwoBmcqqBbOP2wLclJ7xol6054n8XqUtk44=";
    cp313-x86_64-darwin = cp313-aarch64-darwin;
    cp313-x86_64-linux = "sha256-wVm6yMfrL0rMgVebo/WGAyb7LKOp139g8U0GhgCbRoc=";
    cp314-aarch64-darwin = "sha256-QCytKZtPSzdGDKg0LjFbJS/y5whqa8mcotNfecYXPVw=";
    cp314-aarch64-linux = "sha256-qHAOVJwmZ6ojUDSmFJrxaiE4unwfns0VtVdUcEq2zq8=";
    cp314-x86_64-darwin = cp314-aarch64-darwin;
    cp314-x86_64-linux = "sha256-WUSCCjJ4uWTwxIsasIOizEmZ9HuZBoWVV0F3wPiXOCY=";
  };
  hash =
    hashes."${pyShortVersion}-${stdenv.system}"
      or (throw "Unsupported Python version: ${python.pythonVersion}");
in
buildPythonPackage rec {
  pname = "gurobipy";
  version = "13.0.1";
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
