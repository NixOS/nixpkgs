{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytest,
  six,
}:

buildPythonPackage rec {
  pname = "docrep";
  version = "0.3.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-7YoX4gGr2CnvjaeKC29NUfuZpMvQVUrb7TMJKX+WQxQ=";
  };

  nativeCheckInputs = [ pytest ];
  propagatedBuildInputs = [ six ];

  checkPhase = ''
    py.test
  '';

  # tests not packaged with PyPi download
  doCheck = false;

  meta = {
    description = "Python package for docstring repetition";
    homepage = "https://github.com/Chilipp/docrep";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ ];
  };
}
