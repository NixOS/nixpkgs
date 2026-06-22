{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
}:

buildPythonPackage rec {
  pname = "rapidfuzz-capi";
  version = ".1.0.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "maxbachmann";
    repo = "rapidfuzz_capi";
    rev = "v${version}";
    hash = "sha256-9PibmRPbg7G4vT9ux0l3/2lYpVJj9WUIks6K65fk9Yg=";
  };

  # upstream has no tests
  doCheck = false;

  pythonImportsCheck = [ "rapidfuzz_capi" ];

  meta = {
    description = "C-API of RapidFuzz, which can be used to extend RapidFuzz from separate packages";
    homepage = "https://github.com/maxbachmann/rapidfuzz_capi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
