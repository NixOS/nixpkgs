{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, jsbeautifier
}:

buildPythonPackage rec {
  pname = "cssbeautifier";
  version = "1.14.9";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-LaQyRy9oFw64VK/5exaiRyH1CQ7javLjEZlZConn9x8=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [ jsbeautifier ];

  # has no tests
  doCheck = false;

  pythonImportsCheck = [ "cssbeautifier" ];

  meta = with lib; {
    description = "CSS unobfuscator and beautifier";
    homepage = "https://pypi.org/project/cssbeautifier/";
    license = licenses.mit;
    maintainers = with maintainers; [ traxys ];
  };
}
