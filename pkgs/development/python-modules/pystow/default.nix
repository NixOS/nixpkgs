{
  lib,
  fetchPypi,
  buildPythonPackage,
  tqdm,
  typing-extensions,
  uv-build,
}:

buildPythonPackage rec {
  pname = "pystow";
  version = "0.10.2";
  pyproject = true;

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-4w/2ZKkJmrk1ayXk+jxpoWEqMsLFuB6KI7TI78L7im0=";
  };

  build-system = [ uv-build ];
  propagatedBuildInputs = [
    tqdm
    typing-extensions
  ];

  pythonImportsCheck = [ "pystow" ];

  preDistPhases = [ "pystowHomePhase" ];
  pystowHomePhase = ''
    export PYSTOW_HOME="$TMPDIR/pystow-home"
  '';

  meta = {
    description = "Select and manage data locations for Python packages";
    homepage = "https://github.com/cthoyt/pystow";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ philocalyst ];
  };
}
