{ lib, buildPythonPackage, fetchPypi
, psutil
, pytest
, setuptools_scm
}:

buildPythonPackage rec {
  pname = "pytest-xprocess";
  version = "0.17.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2506d637c4f54c65dd195c1d094abdeedacc9bf0689131d847a324ad0fc951c0";
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
