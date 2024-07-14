{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytest,
  readme-renderer,
}:

buildPythonPackage rec {
  pname = "readme";
  version = "0.7.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-MvvhU4pDfaFg+k5EdycL/c2IduLjZNDRKJgwJkRJYjE=";
  };

  nativeCheckInputs = [ pytest ];

  propagatedBuildInputs = [ readme-renderer ];

  checkPhase = ''
    pytest
  '';

  # tests are not included with pypi release
  # package is not readme-renderer
  doCheck = false;

  meta = with lib; {
    description = "Readme is a library for rendering readme descriptions for Warehouse";
    homepage = "https://github.com/pypa/readme";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
