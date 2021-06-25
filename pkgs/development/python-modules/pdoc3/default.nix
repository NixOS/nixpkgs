{ lib, buildPythonPackage, fetchPypi
, pythonOlder
, Mako
, markdown
, setuptools-git
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "pdoc3";
  version = "0.9.2";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9df5d931f25f353c69c46819a3bd03ef96dd286f2a70bb1b93a23a781f91faa1";
  };

  nativeBuildInputs = [ setuptools-git setuptools-scm ];
  propagatedBuildInputs = [ Mako markdown ];

  meta = with lib; {
    description = "Auto-generate API documentation for Python projects.";
    homepage = "https://pdoc3.github.io/pdoc/";
    license = with licenses; [ agpl3Plus ];
    maintainers = with maintainers; [ catern ];
  };
}
