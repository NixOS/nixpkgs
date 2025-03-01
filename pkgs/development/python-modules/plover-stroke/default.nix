{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "plover-stroke";
  version = "1.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    inherit pname version;
    owner = "openstenoproject";
    repo = "plover_stroke";
    rev = "${version}";
    hash = "sha256-A75OMzmEn0VmDAvmQCp6/7uptxzwWJTwsih3kWlYioA=";
  };

  nativeBuildInputs = [ setuptools ];

  pythonImportsCheck = [ "plover_stroke" ];

  meta = with lib; {
    description = "Helper class for working with steno strokes.";
    license = licenses.gpl2;
    maintainers = with maintainers; [
      nilscc
    ];
  };
}
