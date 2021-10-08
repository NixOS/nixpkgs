{ lib
, fetchPypi
, buildPythonPackage
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "makefun";
  version = "1.12.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4d0e90ca3fdbdeb6a4a0891e2da7d4b8e80386e19e6db91ce29b8aa5c876ecfe";
  };

  nativeBuildInputs = [ setuptools-scm ];

  # Disabling tests for now due to various (transitive) dependencies on modules
  # from @smarie which are, as of yet, not part of nixpkgs. Also introduces
  # a tricky dependency: makefun tests depend on pytest-cases, installing
  # pytest-cases depends on makefun.
  doCheck = false;

  pythonImportsCheck = [ "makefun" ];

  meta = with lib; {
    homepage = "https://github.com/smarie/python-makefun";
    description = "Small library to dynamically create python functions";
    license = licenses.bsd2;
    maintainers = with maintainers; [ veehaitch ];
  };
}
