{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,

  pytestCheckHook,
  beautifulsoup4,
}:

buildPythonPackage {
  pname = "pyluach";
  version = "2.2.0";
  format = "pyproject";
  src = fetchFromGitHub {
    owner = "simlist";
    repo = "pyluach";
    rev = "v2.2.0.post1";
    sha256 = "sha256-1DmxZsqpRgYaGEiyan6peRwOgQcZ8uuB0nKvRafaCJs=";
  };

  nativeBuildInputs = [ flit-core ];

  nativeCheckInputs = [ pytestCheckHook ];

  checkInputs = [ beautifulsoup4 ];

  meta = with lib; {
    description = "Library for dealing with Hebrew (Jewish) calendar dates.";
    homepage = "https://github.com/simlist/pyluach";
    license = licenses.mit;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = [ maintainers.thardin ];
  };
}
