{ lib
, buildPythonPackage
, fetchPypi
, setuptools-scm
, pytest-runner
, pytest
}:

buildPythonPackage rec {
  pname = "multiset";
  version = "3.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e45671cae8385a8e6248a9b07a3a83280c2d0cc4312713058cfbacdc5ec9973e";
  };

  buildInputs = [ setuptools-scm pytest-runner ];
  nativeCheckInputs = [ pytest ];

  meta = with lib; {
    description = "An implementation of a multiset";
    homepage = "https://github.com/wheerd/multiset";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
