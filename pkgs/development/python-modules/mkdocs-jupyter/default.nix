{ buildPythonPackage
, fetchpatch
, fetchPypi
, ipykernel
, jupytext
, lxml
, mkdocs 
, mkdocs-material
, nbconvert
, pygments
, pytestCheckHook
, pytest-cov
, pyyaml
, requests
, stdlib-list
}:

buildPythonPackage rec {
  pname = "mkdocs-jupyter";
  version = "0.22.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-WFzGm+pMufr2iYExl43JqbIlCR7UtghPWrZWUqXhIYU=";
  };

  postPatch = ''
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

  checkInputs = [
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
