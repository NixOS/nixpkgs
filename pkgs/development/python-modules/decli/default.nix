{ buildPythonPackage
, lib
, fetchPypi
, setuptools
}:

buildPythonPackage rec {
  pname = "decli";
  version = "0.6.1";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-7YjMuUdwHo5VCbeUX9pW4VDirHSmnyXUeshe8wqwwPA=";
  };

  nativeBuildInputs = [ setuptools ];

  pythonImportsCheck = [ "decli" ];

  meta = with lib; {
    description = "Minimal, easy to use, declarative command line interface tool";
    homepage = "https://github.com/Woile/decli";
    license = licenses.mit;
    maintainers = with maintainers; [ lovesegfault ];
  };
}
