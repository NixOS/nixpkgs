{ lib, buildPythonPackage, fetchPypi
, psutil
, pytest
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "pytest-xprocess";
  version = "0.19.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-GCDFSdZx7bLInCX/HjjHDs2g/v4oDxPEWiyMbWbXtQ4=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  buildInputs = [ pytest ];

  propagatedBuildInputs = [ psutil ];

  # Remove test QoL package from install_requires
  postPatch = ''
    substituteInPlace setup.py \
      --replace "'pytest-cache', " ""
  '';

  # There's no tests in repo
  doCheck = false;

  meta = with lib; {
    description = "Pytest external process plugin";
    homepage = "https://github.com/pytest-dev";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
