{ lib
, buildPythonPackage
, fetchFromGitHub
, jupyter_server
, pytestCheckHook
, pytest-tornasync
}:

buildPythonPackage rec {
  pname = "notebook-shim";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "jupyter";
    repo = "notebook_shim";
    rev = "v${version}";
    sha256 = "sha256-5oIYj8SdC4E0N/yFxsmD2p4VkStHvqrVqAwb/htyPm4=";
  };

  propagatedBuildInputs = [ jupyter_server ];

  preCheck = ''
    mv notebook_shim/conftest.py notebook_shim/tests
    cd notebook_shim/tests
  '';

  # TODO: understand & possibly fix why tests fail. On github most testfiles
  # have been comitted with msgs "wip" though.
  doCheck = false;

  checkInputs = [
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
    maintainers = with maintainers; [ friedelino ];
  };
}
