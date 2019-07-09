{ lib
, buildPythonPackage
, fetchPypi
, setuptools_scm
, importlib-metadata
}:

buildPythonPackage rec {
  pname = "pluggy";
  version = "0.8.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8ddc32f03971bfdf900a81961a48ccf2fb677cf7715108f85295c67405798616";
  };

  checkPhase = ''
    py.test
  '';

  # To prevent infinite recursion with pytest
  doCheck = false;

  nativeBuildInputs = [ setuptools_scm ];

  propagatedBuildInputs = [ importlib-metadata ];

  meta = with lib; {
    description = "Plugin and hook calling mechanisms for Python";
    homepage = "https://github.com/pytest-dev/pluggy";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
