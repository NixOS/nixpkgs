{ lib
, buildPythonPackage
, fetchPypi
, isPy27
, pytest
, pytest-cov
, nbval
, jupyter-packaging
, ipywidgets
, numpy
, six
, traittypes
}:

buildPythonPackage rec {
  pname = "ipydatawidgets";
<<<<<<< HEAD
  version = "4.3.5";
=======
  version = "4.3.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-OU8kiVdlh8/XVTd6CaBn9GytIggZZQkgIf0avL54Uqg=";
=======
    hash = "sha256-T7LOaT+yaM2ukAN0z6GpFkHiLZUU0eweYtp0cFCST3Y=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    jupyter-packaging
  ];

  setupPyBuildFlags = [ "--skip-npm" ];

  propagatedBuildInputs = [
    ipywidgets
    numpy
    six
    traittypes
  ];

  nativeCheckInputs = [ pytest pytest-cov nbval ];

  checkPhase = "pytest ipydatawidgets/tests";

  meta = {
    description = "Widgets to help facilitate reuse of large datasets across different widgets";
    homepage = "https://github.com/vidartf/ipydatawidgets";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
