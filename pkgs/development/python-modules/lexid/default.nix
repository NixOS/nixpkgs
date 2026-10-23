{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  click,
}:

buildPythonPackage rec {
  pname = "lexid";
  version = "2021.1006";
  format = "setuptools";
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-UJo6TMkm09vyKyA7GKTGbCXmRz+3wODTA3RTOsKLr+U=";
  };

  prePatch = ''
    # Disable lib3to6, since we're only building this on 3.6+ anyway.
    substituteInPlace setup.py \
      --replace 'if any(arg.startswith("bdist") for arg in sys.argv):' 'if False:'
  '';

  propagatedBuildInputs = [ click ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Micro library to increment lexically ordered numerical ids";
    mainProgram = "lexid_incr";
    homepage = "https://pypi.org/project/lexid/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kfollesdal ];
  };
}
