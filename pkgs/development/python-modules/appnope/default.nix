{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "appnope";
  version = "0.1.4";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "minrk";
    repo = "appnope";
    rev = version;
    hash = "sha256-We7sZKVbQFIMdZpS+VMdi0RH1O/qtFNrfJNg/98tO5A=";
  };

  checkInputs = [ pytestCheckHook ];

  meta = {
    description = "Disable App Nap on macOS";
    homepage = "https://github.com/minrk/appnope";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ OPNA2608 ];
    # Not Darwin-specific because dummy fallback may be used cross-platform
  };
}
