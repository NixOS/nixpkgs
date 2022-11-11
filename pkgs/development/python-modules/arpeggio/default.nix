{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "arpeggio";
  version = "2.0.0";

  src = fetchPypi {
    pname = "Arpeggio";
    inherit version;
    sha256 = "sha256-1rA4OQGbuKaHhfkpLuajaxlU64S5JbhKa4peHibT7T0=";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "pytest-runner" ""
  '';

  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "arpeggio" ];

  meta = with lib; {
    description = "Recursive descent parser with memoization based on PEG grammars (aka Packrat parser)";
    homepage = "https://github.com/textX/Arpeggio";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
