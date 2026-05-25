{
  lib,
  buildPythonPackage,
  fetchPypi,
  poetry-core,
}:

buildPythonPackage rec {
  pname = "krfzf-py";
  version = "0.0.6";
  pyproject = true;

  src = fetchPypi {
    pname = "krfzf_py";
    inherit version;
    hash = "sha256-/M9Atu9MLAGmnEdx6tknMJAit2o4Xt971uQ7pb0CBCk=";
  };

  nativeBuildInputs = [ poetry-core ];

  pythonImportsCheck = [ "fzf" ];

  meta = {
    description = "Pythonic Fzf Wrapper";
    downloadPage = "https://github.com/justfoolingaround/fzf.py";
    homepage = "https://pypi.org/project/krfzf-py/";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
}
