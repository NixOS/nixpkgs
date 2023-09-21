{ lib
, buildPythonPackage
, fetchPypi
, psutil
, py
, pytest
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "pytest-xprocess";
  version = "0.22.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-WZ7iW5OOjyWeGNnFtNY4SIT4pqKMpR7tMtDZUmvc93w=";
  };

  postPatch = ''
    # Remove test QoL package from install_requires
    substituteInPlace setup.py \
      --replace "'pytest-cache', " ""
  '';

  nativeBuildInputs = [
    setuptools-scm
  ];

  buildInputs = [
    pytest
  ];

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
