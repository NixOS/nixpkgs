{
  lib,
  buildPythonPackage,
  fetchPypi,
  makefun,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "decopatch";
  version = "1.4.10";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-lX9JyT9BUBgsI/j7UdE7syE+DxenngnIzKcFdZi1VyA=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [ makefun ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "pytest-runner" ""
  '';

  pythonImportsCheck = [ "decopatch" ];

  # Tests would introduce multiple circular dependencies
  # Affected: makefun, pytest-cases
  doCheck = false;

  meta = {
    description = "Python helper for decorators";
    homepage = "https://github.com/smarie/python-decopatch";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
  };
}
