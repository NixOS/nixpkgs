{ lib
, buildPythonPackage
, fetchPypi
, setuptools-scm
}:
buildPythonPackage rec {
  pname = "rpmfile";
  version = "1.0.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e56cfc10e1a7d953b1890d81652a89400c614f4cdd9909464aece434d93c3a3e";
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
    maintainers = teams.determinatesystems.members;
  };
}
