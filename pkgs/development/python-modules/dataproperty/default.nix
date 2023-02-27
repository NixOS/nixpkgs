{ buildPythonPackage
, fetchFromGitHub
, lib
, mbstrdecoder
, typepy
, pytestCheckHook
, termcolor
}:

buildPythonPackage rec {
  pname = "dataproperty";
  version = "0.55.0";

  src = fetchFromGitHub {
    owner = "thombashi";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-ODSrKZ8M/ni9r2gkVIKWaKkdr+3AVi4INkEKJ+cmb44=";
  };

  propagatedBuildInputs = [ mbstrdecoder typepy ];

  nativeCheckInputs = [ pytestCheckHook ];
  checkInputs = [ termcolor ];

  # Tests fail, even on non-nixos
  pytestFlagsArray = [
    "--deselect test/test_dataproperty.py::Test_DataPeroperty_len::test_normal_ascii_escape_sequence"
    "--deselect test/test_dataproperty.py::Test_DataPeroperty_is_include_ansi_escape::test_normal"
    "--deselect test/test_dataproperty.py::Test_DataPeroperty_repr::test_normal"
  ];

  meta = with lib; {
    homepage = "https://github.com/thombashi/dataproperty";
    description = "A library for extracting properties from data";
    maintainers = with maintainers; [ genericnerdyusername ];
    license = licenses.mit;
  };
}
