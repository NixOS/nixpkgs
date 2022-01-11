{ lib, buildPythonPackage, fetchPypi
, psutil
, pytest
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "pytest-xprocess";
  version = "0.18.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fd9f30ed1584b5833bc34494748adf0fb9de3ca7bacc4e88ad71989c21cba266";
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
