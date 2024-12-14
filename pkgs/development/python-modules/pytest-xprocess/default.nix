{
  lib,
  buildPythonPackage,
  fetchPypi,
  psutil,
  py,
  pytest,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "pytest-xprocess";
  version = "1.0.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-FeJwY3WG6rxWdV7l/MgcSL20a6fvfA1bG2QwLQgMxg8=";
  };

  postPatch = ''
    # Remove test QoL package from install_requires
    substituteInPlace setup.py \
      --replace "'pytest-cache', " ""
  '';

  nativeBuildInputs = [ setuptools-scm ];

  buildInputs = [ pytest ];

  propagatedBuildInputs = [
    psutil
    py
  ];

  # There's no tests in repo
  doCheck = false;

  meta = with lib; {
    description = "Pytest external process plugin";
    homepage = "https://github.com/pytest-dev";
    license = licenses.mit;
    maintainers = [ ];
  };
}
