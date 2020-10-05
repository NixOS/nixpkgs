{ lib, buildPythonPackage, fetchPypi
, psutil
, pytest
, setuptools_scm
}:

buildPythonPackage rec {
  pname = "pytest-xprocess";
  version = "0.15.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "431e177013ae4cdc621fca4a3b0de12598ce309d824cc29d11e54dedceeaf6ce";
  };

  nativeBuildInputs = [ setuptools_scm ];
  propagatedBuildInputs = [ psutil pytest ];

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
