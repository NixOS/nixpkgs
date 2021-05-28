{ lib, buildPythonPackage, fetchPypi
, psutil
, pytest
, setuptools_scm
}:

buildPythonPackage rec {
  pname = "pytest-xprocess";
  version = "0.14.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "06g1j5079ddl2sd3pxh2jg6g83b2z3l5hzbadiry2xg673dcncmb";
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
