{
  lib,
  buildPythonPackage,
  fetchPypi,
  flit-core,
  ipython,
  matplotlib,
  numpy,
  pillow,
}:

buildPythonPackage rec {
  pname = "mediapy";
  version = "1.2.6";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-LIZs+goXAhP3cbHdVYSi6C2NDcD6lJgvg+KarifknIM=";
  };

  nativeBuildInputs = [ flit-core ];

  propagatedBuildInputs = [
    ipython
    matplotlib
    numpy
    pillow
  ];

  pythonImportsCheck = [ "mediapy" ];

  meta = {
    description = "Read/write/show images and videos in an IPython notebook";
    homepage = "https://github.com/google/mediapy";
    changelog = "https://github.com/google/mediapy/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ mcwitt ];
  };
}
