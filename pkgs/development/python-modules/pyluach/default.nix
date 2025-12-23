{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,

  pytestCheckHook,
  beautifulsoup4,
}:

buildPythonPackage rec {
  pname = "pyluach";
  version = "2.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "simlist";
    repo = "pyluach";
    tag = "v${version}";
    hash = "sha256-1DmxZsqpRgYaGEiyan6peRwOgQcZ8uuB0nKvRafaCJs=";
  };

  build-system = [ flit-core ];

  nativeCheckInputs = [ pytestCheckHook ];

  checkInputs = [ beautifulsoup4 ];

  pythonImportsCheck = [ "pyluach" ];

  meta = with lib; {
    description = "Library for dealing with Hebrew (Jewish) calendar dates.";
    homepage = "https://github.com/simlist/pyluach";
    license = licenses.mit;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = [ maintainers.thardin ];
  };
}
