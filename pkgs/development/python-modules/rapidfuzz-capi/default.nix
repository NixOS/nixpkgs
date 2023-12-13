{ lib
, buildPythonPackage
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "rapidfuzz-capi";
  version = "1.0.5";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "maxbachmann";
    repo = "rapidfuzz_capi";
    rev = "v${version}";
    hash = "sha256-0IvJl2JU/k1WbGPWRoucVGbVsEFNPHZT1ozEQAKQnPk=";
  };

  # upstream has no tests
  doCheck = false;

  pythonImportsCheck = [ "rapidfuzz_capi" ];

  meta = with lib; {
    description = "C-API of RapidFuzz, which can be used to extend RapidFuzz from separate packages";
    homepage = "https://github.com/maxbachmann/rapidfuzz_capi";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
