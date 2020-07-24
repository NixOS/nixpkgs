{ lib, buildPythonPackage, fetchPypi
, psutil
, pytest
, setuptools_scm
}:

buildPythonPackage rec {
  pname = "pytest-xprocess";
  version = "0.13.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "779aeca517cd9c996d1544bdc510cb3cff40c48136d94bbce6148e27f30a93ff";
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
