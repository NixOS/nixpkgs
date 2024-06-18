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
  version = "0.23.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-+NQEGiChwe8ZQwVOSj33rHtD5/KR9kD0PDTp3MSzTfo=";
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
    maintainers = with maintainers; [ jonringer ];
  };
}
