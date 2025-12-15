{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "coq-tools";
  version = "0.0.39";
  pyproject = true;

  src = fetchPypi {
    pname = "coq_tools";
    inherit version;
    hash = "sha256-MPgu5inr2CMOU3qlF9v8QtqhkPuP/uIQrJYyfmpZBxE=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "coq_tools" ];

  meta = {
    description = "Tools for working with Coq proof assistant";
    homepage = "https://pypi.org/project/coq-tools/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ siraben ];
    platforms = lib.platforms.all;
  };
}
