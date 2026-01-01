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
<<<<<<< HEAD
    aarch64-darwin = "macosx_10_13_universal2";
    aarch64-linux = "manylinux_2_26_aarch64";
=======
    aarch64-darwin =
      if pyShortVersion == "cp313" then "macosx_10_13_universal2" else "macosx_10_9_universal2";
    aarch64-linux = "manylinux2014_aarch64.manylinux_2_17_aarch64";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    x86_64-darwin = aarch64-darwin;
    x86_64-linux = "manylinux2014_x86_64.manylinux_2_17_x86_64";
  };
  platform = platforms.${stdenv.system} or (throw "Unsupported system: ${stdenv.system}");
  hashes = rec {
<<<<<<< HEAD
    cp312-aarch64-darwin = "sha256-qbdDlsAHHrRDijyLgYZMVKjoqxBPEFhNf+ZHQ0Qo+08=";
    cp312-aarch64-linux = "sha256-1cfo6K3h1l6hzbHNIK2H0Y9uejjyFWAYlczUSvyTLOE=";
    cp312-x86_64-darwin = cp312-aarch64-darwin;
    cp312-x86_64-linux = "sha256-nXcNqkw/Chn+tmcRa1GaQSjTgn3wdnaUbskLOyOSEpo=";
    cp313-aarch64-darwin = "sha256-9anXslqv9KIxf/Dt7xCAqF6/tQFDlWwOMkQookmXDBE=";
    cp313-aarch64-linux = "sha256-0x5gOK+m0LygVFuh6hGfNyaWXclNdfuBppqq7Pu3FoI=";
    cp313-x86_64-darwin = cp313-aarch64-darwin;
    cp313-x86_64-linux = "sha256-rSAMw5aAp+Emz2Xlo2GXrbVsvKRw/CcxcF441N/IsTw=";
=======
    cp312-aarch64-darwin = "sha256-Ag8jJ39jDgeerBFDheq9G9n7SsIvh5btW6bZFc5PFBs=";
    cp312-aarch64-linux = "sha256-crv1RLwFBgu5OQm3lxWs5MD0FhmPdiKphcq7no6Zqhw=";
    cp312-x86_64-darwin = cp312-aarch64-darwin;
    cp312-x86_64-linux = "sha256-s/lxyvJw9nG2/89bk3s8BDClJksPAVKdyGgdYcIh8hU=";
    cp313-aarch64-darwin = "sha256-qFUuR2c8tvH9NR7fj8rYawL4Msv7V9kO8h4Dl+ltE44=";
    cp313-aarch64-linux = "sha256-vgXAdBQcihJsiq7MxBeVqwkaZm6rs5yh/5inS96B5mM=";
    cp313-x86_64-darwin = cp313-aarch64-darwin;
    cp313-x86_64-linux = "sha256-eaMzdm4n/veQLO7vvPAnmhyjk6J6cupi+OMBshqhfVk=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
  hash =
    hashes."${pyShortVersion}-${stdenv.system}"
      or (throw "Unsupported Python version: ${python.pythonVersion}");
in
buildPythonPackage rec {
  pname = "gurobipy";
<<<<<<< HEAD
  version = "13.0.0";
=======
  version = "12.0.3";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
