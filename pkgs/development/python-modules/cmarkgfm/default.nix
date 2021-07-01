{ lib
, buildPythonPackage
, cffi
, fetchPypi
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "cmarkgfm";
  version = "0.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-7Cv41XmcS1u/uuMKSh38sGUS8uF+nuYLp+HTkDGFgvw=";
  };

  propagatedBuildInputs = [ cffi ];

  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "cmarkgfm" ];

  meta = with lib; {
    description = "Minimal bindings to GitHub's fork of cmark";
    homepage = "https://github.com/jonparrott/cmarkgfm";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
