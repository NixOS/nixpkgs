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
    sha256 = "ec2bf8d5799c4b5bbfbae30a4a1dfcb06512f2e17e9ee60ba7e1d390318582fc";
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
