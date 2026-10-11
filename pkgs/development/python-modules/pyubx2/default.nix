{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pynmeagps,
  pyrtcm,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyubx2";
  version = "1.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "semuconsulting";
    repo = "pyubx2";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bb/RLpVP2yd3ybKiiTEzogiYRpi3H9zbxs9lYylaaXI=";
  };

  build-system = [ setuptools ];

  buildInputs = [
    pynmeagps
    pyrtcm
  ];

  pythonImportsCheck = [
    "pyubx2"
  ];

  meta = {
    description = "Python library for parsing and generating UBX GPS/GNSS protocol messages";
    homepage = "https://github.com/semuconsulting/pyubx2";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ luz ];
  };
})
