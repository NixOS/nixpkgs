{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pycayennelpp";
  version = "2.4.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-vfXj5pjOQOZsUGV5Q0DnFJwRR/P9mEOOfqcohcSnhrE=";
  };

  build-system = [ setuptools ];

  # Patch setup.py to remove pytest-runner
  postPatch = ''
    substituteInPlace setup.py \
      --replace '"pytest-runner"' ""
  '';

  doCheck = false;

  meta = {
    description = "Python library for Cayenne Low Power Payload";
    homepage = "https://github.com/smlng/pycayennelpp";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.haylin ];
  };
}
