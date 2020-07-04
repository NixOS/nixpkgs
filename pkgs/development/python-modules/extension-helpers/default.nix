{ lib
, buildPythonPackage
, fetchPypi
, isPy27
, pytestCheckHook
, setuptools_scm
}:

buildPythonPackage rec {
  pname = "extension-helpers";
  version = "0.1";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "10iqjzmya2h4sk765dlm1pbqypwlqyh8rw59a5m9i63d3klnz2mc";
  };

  nativeBuildInputs = [
    setuptools_scm
  ];

  propagatedBuildInputs = [
    pytestCheckHook
  ];

  # avoid importing local module
  preCheck = ''
    cd extension_helpers
  '';

  # assumes setup.py is in pwd
  disabledTests = [ "compiler_module" ];

  meta = with lib; {
    description = "Helpers to assist with building packages with compiled C/Cython extensions";
    homepage = "https://github.com/astropy/extension-helpers";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
