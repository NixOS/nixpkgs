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
    sha256 = "1cc6lz28aa57gs74767xyd3i370lwx046yb5a1nfch6fk3kf7xdx";
  };

  build-system = [ setuptools ];

  # Patch setup.py to remove pytest-runner
  postPatch = ''
    substituteInPlace setup.py \
      --replace '"pytest-runner"' ""
  '';

  doCheck = false;

  meta = with lib; {
    description = "Python library for Cayenne Low Power Payload";
    homepage = "https://github.com/smlng/pycayennelpp";
    license = licenses.mit;
    maintainers = [ lib.maintainers.haylin ];
  };
}
