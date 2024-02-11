{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, hatchling
, hatch-jupyter-builder
, ipywidgets
, jupyter-ui-poll
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "ipyniivue";
  version = "1.1.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-kym7949VI6C+62p3IOQ2QIzWnuSBcrmySb83oqUwhjI=";
  };

  # We do not need the jupyterlab build dependency, because we do not need to
  # build any JS components; these are present already in the PyPI artifact.
  #
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace '"jupyterlab==3.*",' ""
  '';

  nativeBuildInputs = [
    hatchling
    hatch-jupyter-builder
  ];

  propagatedBuildInputs = [ ipywidgets jupyter-ui-poll ];

  nativeCheckImports = [ pytestCheckHook ];
  pythonImportsCheck = [ "ipyniivue" ];

  meta = with lib; {
    description = "Show a nifti image in a webgl 2.0 canvas within a jupyter notebook cell";
    homepage = "https://github.com/niivue/ipyniivue";
    changelog = "https://github.com/niivue/ipyniivue/releases/tag/${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
