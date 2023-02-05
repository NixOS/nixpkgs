{ lib
, buildPythonPackage
, fetchPypi
, isPy27
, pytest
, pytestCheckHook
, vcrpy
, citeproc-py
, requests
, six
}:

buildPythonPackage rec {
  pname = "duecredit";
  version = "0.9.1";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "f6192ce9315b35f6a67174761291e61d0831e496e8ff4acbc061731e7604faf8";
  };

  propagatedBuildInputs = [ citeproc-py requests six ];

  nativeCheckInputs = [ pytest pytestCheckHook vcrpy ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  pythonImportsCheck = [ "duecredit" ];

  meta = with lib; {
    homepage = "https://github.com/duecredit/duecredit";
    description = "Simple framework to embed references in code";
    license = licenses.bsd2;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
