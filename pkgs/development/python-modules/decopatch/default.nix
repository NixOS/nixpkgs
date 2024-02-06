{ lib
, buildPythonPackage
, fetchPypi
, makefun
, setuptools-scm
, pythonOlder
}:

buildPythonPackage rec {
  pname = "decopatch";
  version = "1.4.10";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-lX9JyT9BUBgsI/j7UdE7syE+DxenngnIzKcFdZi1VyA=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    makefun
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "pytest-runner" ""
  '';

  pythonImportsCheck = [
    "decopatch"
  ];

  # Tests would introduce multiple cirucular dependencies
  # Affected: makefun, pytest-cases
  doCheck = false;

  meta = with lib; {
    description = "Python helper for decorators";
    homepage = "https://github.com/smarie/python-decopatch";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
