{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  jupyter-server,
  pytestCheckHook,
  pytest-tornasync,
}:

buildPythonPackage rec {
  pname = "notebook-shim";
  version = "0.2.4";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "jupyter";
    repo = "notebook_shim";
    rev = "refs/tags/v${version}";
    hash = "sha256-CWnXOKE1xvr+a/qWNY6XCTB5+G/fg2O/glgeLzYD+Zc=";
  };

  nativeBuildInputs = [ hatchling ];
  propagatedBuildInputs = [ jupyter-server ];

  preCheck = ''
    mv notebook_shim/conftest.py notebook_shim/tests
    cd notebook_shim/tests
  '';

  # TODO: understand & possibly fix why tests fail. On github most testfiles
  # have been comitted with msgs "wip" though.
  doCheck = false;

  nativeCheckInputs = [
    pytestCheckHook
    pytest-tornasync
  ];

  pythonImportsCheck = [ "notebook_shim" ];

  meta = with lib; {
    description = "Switch frontends to Jupyter Server";
    longDescription = ''
      This project provides a way for JupyterLab and other frontends to switch
      to Jupyter Server for their Python Web application backend.
    '';
    homepage = "https://github.com/jupyter/notebook_shim";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
