{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  pytest,
  numpy,
  scipy,
  matplotlib,
  docutils,
  pyopencl,
  opencl-headers,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "sasmodels";
  version = "1.0.7";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "SasView";
    repo = "sasmodels";
    rev = "refs/tags/v${version}";
    hash = "sha256-GZQYVvQ4bEBizTmJ+o5fIfGr8gn2/4uD3PxIswEjzSE=";
  };

  buildInputs = [ opencl-headers ];

  propagatedBuildInputs = [
    docutils
    matplotlib
    numpy
    scipy
    pyopencl
  ];

  # Note: the 1.0.5 release should be compatible with pytest6, so this can
  # be set back to 'pytest' at that point
  nativeCheckInputs = [ pytest ];

  checkPhase = ''
    HOME=$(mktemp -d) py.test -c ./pytest.ini
  '';

  pythonImportsCheck = [ "sasmodels" ];

  meta = with lib; {
    description = "Library of small angle scattering models";
    homepage = "https://github.com/SasView/sasmodels";
    license = licenses.bsd3;
    maintainers = with maintainers; [ rprospero ];
  };
}
