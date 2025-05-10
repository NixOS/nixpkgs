{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  lilypond,
}:

buildPythonPackage rec {
  pname = "jianpu-ly";
  version = "1.853";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "jianpu_ly";
    hash = "sha256-LNXFkcSTepbAC36lpeSbxZYHA9O6hOp4MRe6LgbpbZQ=";
  };

  dependencies = [ lilypond ];

  build-system = [ setuptools ];

  pythonImportsCheck = [ "jianpu_ly" ];

  # no tests in shipped with upstream
  doCheck = false;

  meta = {
    homepage = "https://ssb22.user.srcf.net/mwrhome/jianpu-ly.html";
    description = "Assists with printing jianpu";
    changelog = "https://github.com/ssb22/jianpu-ly/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ifurther ];
  };
}
