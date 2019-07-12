{ lib, buildPythonPackage, fetchPypi
, psutil
, pytest
}:

buildPythonPackage rec {
  pname = "pytest-xprocess";
  version = "0.12.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "06w2acg0shy0vxrmnxpqclimhgfjys5ql5kmmzr7r1lai46x1q2h";
  };

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
