{
  lib,
  buildPythonPackage,
  fetchPypi,
  uv-build,
  numpy,
}:

buildPythonPackage rec {
  pname = "numpy-typing-compat";
  version = "20250818.2.3";
  pyproject = true;

  src = fetchPypi {
    pname = "numpy_typing_compat";
    inherit version;
    hash = "sha256-cug9U1tjXWaLpzFeQ66AvhRppvrqb8ltMSUW85s9j6U=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"uv_build>=0.8.11,<0.9.0"' '"uv_build>=0.8.11"'
  '';

  build-system = [
    uv-build
  ];

  dependencies = [
    numpy
  ];

  pythonImportsCheck = [
    "numpy_typing_compat"
  ];

  meta = {
    description = "Static typing compatibility layer for older versions of NumPy";
    homepage = "https://pypi.org/project/numpy-typing-compat/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ tm-drtina ];
  };
}
