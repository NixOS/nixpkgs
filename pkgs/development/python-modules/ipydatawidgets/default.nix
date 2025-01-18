{
  lib,
  buildPythonPackage,
  fetchPypi,
  isPy27,
  pytestCheckHook,
  nbval,
  jupyter-packaging,
  ipywidgets,
  numpy,
  six,
  traittypes,
}:

buildPythonPackage rec {
  pname = "ipydatawidgets";
  version = "4.3.5";
  format = "setuptools";

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-OU8kiVdlh8/XVTd6CaBn9GytIggZZQkgIf0avL54Uqg=";
  };

  nativeBuildInputs = [ jupyter-packaging ];

  setupPyBuildFlags = [ "--skip-npm" ];

  propagatedBuildInputs = [
    ipywidgets
    numpy
    six
    traittypes
  ];

  nativeCheckInputs = [
    pytestCheckHook
    nbval
  ];

  meta = with lib; {
    description = "Widgets to help facilitate reuse of large datasets across different widgets";
    homepage = "https://github.com/vidartf/ipydatawidgets";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
