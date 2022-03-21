{ lib
, fetchFromGitHub
, buildPythonPackage
, pytest
, numpy
, scipy
, matplotlib
, docutils
, pyopencl
, opencl-headers
, pythonOlder
}:

buildPythonPackage rec {
  pname = "sasmodels";
  version = "1.0.6";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "SasView";
    repo = "sasmodels";
    rev = "v${version}";
    hash = "sha256-RVEPu07gp1ScciJQmjizyELcOD2WSjIlxunj5LnmXdw=";
  };

  buildInputs = [
    opencl-headers
  ];

  propagatedBuildInputs = [
    docutils
    matplotlib
    numpy
    scipy
    pyopencl
  ];

  # Note: the 1.0.5 release should be compatible with pytest6, so this can
  # be set back to 'pytest' at that point
  checkInputs = [
    pytest
  ];

  checkPhase = ''
    HOME=$(mktemp -d) py.test -c ./pytest.ini
  '';

  pythonImportsCheck = [
    "sasmodels"
  ];

  meta = with lib; {
    description = "Library of small angle scattering models";
    homepage = "https://github.com/SasView/sasmodels";
    license = licenses.bsd3;
    maintainers = with maintainers; [ rprospero ];
  };
}
