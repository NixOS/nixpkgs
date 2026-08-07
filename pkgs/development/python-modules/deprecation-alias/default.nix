{
  buildPythonPackage,
  fetchPypi,
  lib,
  hatch-requirements-txt,
  deprecation,
  packaging,
}:
buildPythonPackage rec {
  pname = "deprecation-alias";
  version = "0.4.0";
  pyproject = true;

  src = fetchPypi {
    pname = "deprecation_alias";
    inherit version;
    hash = "sha256-pY0udEkceDTp0xh4jaYCcvovga64FLQFWkupCgpBdA8=";
  };

  build-system = [ hatch-requirements-txt ];

  dependencies = [
    deprecation
    packaging
  ];

  meta = {
    description = "Wrapper around ‘deprecation’ providing support for deprecated aliases";
    homepage = "https://github.com/domdfcoding/deprecation-alias";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tyberius-prime ];
  };
}
