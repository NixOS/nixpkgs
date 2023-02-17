{ buildPythonPackage
, fetchPypi
, ipykernel
, jupytext
, lib
, mkdocs
, mkdocs-material
, nbconvert
, pygments
, pytestCheckHook
, pytest-cov
}:

buildPythonPackage rec {
  pname = "mkdocs-jupyter";
  version = "0.22.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-WFzGm+pMufr2iYExl43JqbIlCR7UtghPWrZWUqXhIYU=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "nbconvert>=6.2.0,<7.0.0" "nbconvert>=6.2.0"
    substituteInPlace mkdocs_jupyter/tests/test_base_usage.py \
          --replace "[\"mkdocs\"," "[\"${mkdocs.out}/bin/mkdocs\","
  '';

  propagatedBuildInputs = [
    nbconvert
    jupytext
    mkdocs
    mkdocs-material
    pygments
    ipykernel
  ];

  pythonImportsCheck = [ "mkdocs_jupyter" ];

  nativeCheckInputs = [
    pytest-cov
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Use Jupyter Notebook in mkdocs";
    homepage = "https://github.com/danielfrg/mkdocs-jupyter";
    license = licenses.asl20;
    maintainers = with maintainers; [ net-mist ];
  };
}
