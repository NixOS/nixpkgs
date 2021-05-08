{ lib
, buildPythonPackage
, fetchpatch
, fetchPypi
, pytestCheckHook
, hypothesis
, six
, strict-rfc3339
}:

buildPythonPackage rec {
  pname = "rfc3339-validator";
  version = "0.1.3";

  src = fetchPypi {
    pname = "rfc3339_validator";
    inherit version;
    sha256 = "7a578aa0740e9ee2b48356fe1f347139190c4c72e27f303b3617054efd15df32";
  };

  patches = [
    # Fixes test failure on darwin. Filed upstream: https://github.com/naimetti/rfc3339-validator/pull/3.
    # Not yet merged.
    (fetchpatch {
      url = "https://github.com/rmcgibbo/rfc3339-validator/commit/4b6bb62c30bd158d3b4663690dcba1084ac31770.patch";
      sha256 = "0h9k82hhmp2xfzn49n3i47ws3rpm9lvfs2rjrds7hgx5blivpwl6";
    })
  ];

  propagatedBuildInputs = [ six ];

  checkInputs = [ pytestCheckHook hypothesis strict-rfc3339 ];
  pythonImportsCheck = [ "rfc3339_validator" ];

  meta = with lib; {
    description = "RFC 3339 validator for Python";
    homepage = "https://github.com/naimetti/rfc3339-validator";
    license = licenses.mit;
    maintainers = with maintainers; [ AluisioASG ];
  };
}
