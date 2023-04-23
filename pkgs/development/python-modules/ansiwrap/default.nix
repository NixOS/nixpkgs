{ lib
, ansicolors
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
, textwrap3
}:

buildPythonPackage rec {
  pname = "ansiwrap";
  version = "0.8.4";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "ca0c740734cde59bf919f8ff2c386f74f9a369818cdc60efe94893d01ea8d9b7";
  };

  postPatch = ''
    # https://github.com/jonathaneunice/ansiwrap/issues/18
    substituteInPlace test/test_ansiwrap.py \
      --replace "set(range(20, 120)).difference(LINE_LENGTHS)" "sorted(set(range(20, 120)).difference(LINE_LENGTHS))" \
      --replace "set(range(120, 400)).difference(LINE_LENGTHS)" "sorted(set(range(120, 400)).difference(LINE_LENGTHS))"
  '';

  checkInputs = [
    ansicolors
    pytestCheckHook
  ];

  propagatedBuildInputs = [
    textwrap3
  ];

  pythonImportsCheck = [
    "ansiwrap"
  ];

  meta = with lib; {
    description = "Textwrap, but savvy to ANSI colors and styles";
    homepage = "https://github.com/jonathaneunice/ansiwrap";
    changelog = "https://github.com/jonathaneunice/ansiwrap/blob/master/CHANGES.yml";
    license = licenses.asl20;
    maintainers = with maintainers; [ costrouc ];
  };
}
