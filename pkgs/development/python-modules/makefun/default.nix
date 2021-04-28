{ lib
, fetchPypi
, buildPythonPackage
, setuptools_scm
}:

buildPythonPackage rec {
  pname = "makefun";
  version = "1.11.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-2qNQpILtWLVyREPGUUMhkem5ewyDdDh50JExccaigIU=";
  };

  nativeBuildInputs = [ setuptools_scm ];

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
