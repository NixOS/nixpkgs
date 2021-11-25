{ lib, pythonOlder, buildPythonPackage, fetchPypi, pytestCheckHook, click }:

buildPythonPackage rec {
  pname = "lexid";
  version = "2021.1006";
  disabled = pythonOlder "3.6";
  src = fetchPypi {
    inherit pname version;
    sha256 = "509a3a4cc926d3dbf22b203b18a4c66c25e6473fb7c0e0d30374533ac28bafe5";
  };

  prePatch = ''
    # Disable lib3to6, since we're only building this on 3.6+ anyway.
    substituteInPlace setup.py \
      --replace 'if any(arg.startswith("bdist") for arg in sys.argv):' 'if False:'
  '';

  propagatedBuildInputs = [ click ];

  checkInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "micro library to increment lexically ordered numerical ids";
    homepage = "https://pypi.org/project/lexid/";
    license = licenses.mit;
    maintainers = with maintainers; [ kfollesdal ];
  };
}
