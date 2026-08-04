{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  poetry-core,
  pandas,
  scikit-learn,
}:

buildPythonPackage (finalAttrs: {
  pname = "datasieve";
  version = "0.1.9";
  src = fetchFromGitHub {
    owner = "emergentmethods";
    repo = "datasieve";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5TNqggX0Yebyn0sBe2BFEZDwXw5EpbPqi6/P1hMcF1U=";
  };
  pyproject = true;
  build-system = [ poetry-core ];
  buildInputs = [
    pandas
    scikit-learn
  ];
  meta = {
    description = "Adding coherence to the SKLearn pipeline";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ n0099 ];
  };
})
