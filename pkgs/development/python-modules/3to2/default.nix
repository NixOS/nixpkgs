{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytest,
}:

buildPythonPackage rec {
  pname = "py3to2";
  version = "1.1.1";

  src = fetchPypi {
    inherit version;
    pname = "3to2";
    extension = "zip";
    hash = "sha256-/vULK4ge90PyaZRuEJC3dWe3G7mpzmS3+OaZtWL/aFw=";
  };

  nativeCheckInputs = [ pytest ];

  checkPhase = ''
    py.test lib3to2/tests
  '';

  # Test failing due to upstream issue (https://bitbucket.org/amentajo/lib3to2/issues/50/testsuite-fails-with-new-python-35)
  doCheck = false;

  meta = {
    homepage = "https://bitbucket.org/amentajo/lib3to2";
    description = "Refactors valid 3.x syntax into valid 2.x syntax, if a syntactical conversion is possible";
    mainProgram = "3to2";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ mt-caret ];
  };
}
