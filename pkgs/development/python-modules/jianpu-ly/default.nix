{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  lilypond,
}:

buildPythonPackage rec {
  pname = "jianpu-ly";
  version = "1.832";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "jianpu_ly";
    hash = "sha256-7+PM8wHzC5O8o12VjA1aeYIAdv/17TM7RymHyxkq5vs=";
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
