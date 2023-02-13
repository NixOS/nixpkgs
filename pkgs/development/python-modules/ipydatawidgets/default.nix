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
  version = "4.3.2";

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-LyuZf2Vp0+4fT3412wyx2gjAd7IaiPHAHFn1uYajGqY=";
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
