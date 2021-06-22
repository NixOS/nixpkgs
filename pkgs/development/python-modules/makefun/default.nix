{ lib
, fetchPypi
, buildPythonPackage
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "makefun";
  version = "1.11.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "033eed65e2c1804fca84161a38d1fc8bb8650d32a89ac1c5dc7e54b2b2c2e88c";
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
