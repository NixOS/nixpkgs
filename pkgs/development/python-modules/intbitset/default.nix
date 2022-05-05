{ lib
, fetchPypi
, buildPythonPackage
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "intbitset";
  version = "3.0.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-8ebQPGcpkioiPFGEnfZbnpFuYlrvuRF4Tn+azUwgfVM=";
  };

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "intbitset"
  ];

  meta = with lib; {
    description = "C-based extension implementing fast integer bit sets";
    homepage = "https://github.com/inveniosoftware/intbitset";
    license = licenses.lgpl3Only;
    maintainers = teams.determinatesystems.members;
  };
}
