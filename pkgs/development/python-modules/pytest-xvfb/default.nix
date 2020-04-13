{ lib
, buildPythonPackage
, fetchPypi
, pytest
, virtual-display
}:

buildPythonPackage rec {
  pname = "pytest-xvfb";
  version = "1.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a7544ca8d0c7c40db4b40d7a417a7b071c68d6ef6bdf9700872d7a167302f979";
  };

  propagatedBuildInputs = [
    pytest
    virtual-display
  ];

  meta = with lib; {
    description = "A pytest plugin to run Xvfb for tests";
    homepage = "https://github.com/The-Compiler/pytest-xvfb";
    license = licenses.mit;
    maintainers = with maintainers; [ costrouc ];
  };
}
