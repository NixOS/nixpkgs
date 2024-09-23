{
  lib,
  ansicolors,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  pythonAtLeast,
  pythonOlder,
  setuptools,
  textwrap3,
}:

buildPythonPackage rec {
  pname = "ansiwrap";
  version = "0.8.4";
  pyproject = true;

  disabled = pythonOlder "3.7" || pythonAtLeast "3.12";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    hash = "sha256-ygx0BzTN5Zv5Gfj/LDhvdPmjaYGM3GDv6UiT0B6o2bc=";
  };

  postPatch = ''
    # https://github.com/jonathaneunice/ansiwrap/issues/18
    substituteInPlace test/test_ansiwrap.py \
      --replace-fail "set(range(20, 120)).difference(LINE_LENGTHS)" "sorted(set(range(20, 120)).difference(LINE_LENGTHS))" \
      --replace-fail "set(range(120, 400)).difference(LINE_LENGTHS)" "sorted(set(range(120, 400)).difference(LINE_LENGTHS))"
  '';

  build-system = [ setuptools ];

  dependencies = [ textwrap3 ];

  nativeCheckInputs = [
    ansicolors
    pytestCheckHook
  ];

  pythonImportsCheck = [ "ansiwrap" ];

  meta = with lib; {
    description = "Textwrap, but savvy to ANSI colors and styles";
    homepage = "https://github.com/jonathaneunice/ansiwrap";
    changelog = "https://github.com/jonathaneunice/ansiwrap/blob/master/CHANGES.yml";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
