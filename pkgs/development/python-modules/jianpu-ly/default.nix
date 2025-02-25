{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  lilypond,
}:

buildPythonPackage rec {
  pname = "jianpu-ly";
  version = "1.839";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "jianpu_ly";
    hash = "sha256-KFBG/iJeFt2dHHNvhPZlvWxAEO4kLPpNW4R1HRWuUUg=";
  };

  dependencies = [ lilypond ];

  build-system = [ setuptools ];

  pythonImportsCheck = [ "jianpu_ly" ];

  # no tests in shipped with upstream
  doCheck = false;

  meta = {
    homepage = "https://ssb22.user.srcf.net/mwrhome/jianpu-ly.html";
    description = "Assists with printing jianpu";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ifurther ];
  };
}
