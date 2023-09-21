{ lib
, buildPythonPackage
, fetchPypi
, setuptools-scm
}:
buildPythonPackage rec {
  pname = "rpmfile";
  version = "1.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-ZxcHe1QxdG2GBIPMNrnJy6Vd8SRgZ4HOtwsks2be8Cs=";
  };

  # Tests access the internet
  doCheck = false;

  nativeBuildInputs = [
    setuptools-scm
  ];

  pythonImportsCheck = [
    "rpmfile"
  ];

  meta = with lib; {
    description = "Read rpm archive files";
    homepage = "https://github.com/srossross/rpmfile";
    license = licenses.mit;
    maintainers = [ ];
  };
}
