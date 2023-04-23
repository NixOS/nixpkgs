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
  version = "0.9.2";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Dg/Yfp5GzmyUMI6feAwgP+g22JYoQE+L9a+Wp0V77Rw=";
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
