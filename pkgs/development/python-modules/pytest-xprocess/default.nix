{ lib, buildPythonPackage, fetchPypi
, psutil
, pytest
, setuptools_scm
}:

buildPythonPackage rec {
  pname = "pytest-xprocess";
  version = "0.17.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "59c739edee7f3f2258e7c77989241698e356c552f5efb28bb46b478616888bf6";
  };

  nativeBuildInputs = [ setuptools_scm ];

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
