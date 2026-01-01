{
  buildPythonPackage,
  darwin,
  fetchFromGitHub,
  lib,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyobjc-core";
  version = "11.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ronaldoussoren";
    repo = "pyobjc";
    tag = "v${version}";
    hash = "sha256-2qPGJ/1hXf3k8AqVLr02fVIM9ziVG9NMrm3hN1de1Us=";
  };

  sourceRoot = "${src.name}/pyobjc-core";

  build-system = [ setuptools ];

  buildInputs = [
<<<<<<< HEAD
=======
    darwin.DarwinTools
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    darwin.libffi
  ];

  nativeBuildInputs = [
    darwin.DarwinTools # sw_vers
  ];

  env.NIX_CFLAGS_COMPILE = toString [
    "-I${darwin.libffi.dev}/include"
    "-Wno-error=cast-function-type-mismatch"
    "-Wno-error=unused-command-line-argument"
  ];

  pythonImportsCheck = [ "objc" ];

<<<<<<< HEAD
  meta = {
    description = "Python <-> Objective-C bridge";
    homepage = "https://github.com/ronaldoussoren/pyobjc/tree/main/pyobjc-core";
    license = lib.licenses.mit;
    platforms = lib.platforms.darwin;
    maintainers = with lib.maintainers; [ samuela ];
=======
  meta = with lib; {
    description = "Python <-> Objective-C bridge";
    homepage = "https://github.com/ronaldoussoren/pyobjc";
    license = licenses.mit;
    platforms = platforms.darwin;
    maintainers = with maintainers; [ samuela ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
