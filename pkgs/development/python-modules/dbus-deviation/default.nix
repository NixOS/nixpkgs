{ lib
, buildPythonPackage
, fetchPypi
, lxml
, setuptools-git
, setuptools-pep8
, sphinx
}:

buildPythonPackage rec {
  pname = "dbus-deviation";
  version = "0.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "023lkfvbrz3zv68p0qy0xk6r46d7nf4wifwqwmm3gn07d283rfyg";
  };

  propagatedBuildInputs = [
    lxml
  ];

  nativeBuildInputs = [
    setuptools-git
    setuptools-pep8
    sphinx
  ];

  meta = {
    homepage = "https://pypi.org/project/dbus-deviation/";
    description = "a project for parsing D-Bus introspection XML and processing it in various ways";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
}
