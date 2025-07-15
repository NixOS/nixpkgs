{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  pytestCheckHook,
  sphinx,
}:

buildPythonPackage rec {
  pname = "roman-numerals-py";
  version = "3.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "AA-Turner";
    repo = "roman-numerals";
    tag = "v${version}";
    hash = "sha256-YLF09jYwXq48iMvmqbj/cocYJPp7RsCXzbN0DV9gpis=";
  };

  postPatch = ''
    ls -lah
    cp LICENCE.rst python/

    cd python
  '';

  build-system = [ flit-core ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "roman_numerals" ];

  meta = {
    description = "Manipulate roman numerals";
    homepage = "https://github.com/AA-Turner/roman-numerals/";
    changelog = "https://github.com/AA-Turner/roman-numerals/blob/${src.tag}/CHANGES.rst";
    license = lib.licenses.cc0;
    teams = sphinx.meta.teams;
    mainProgram = "roman-numerals-py";
    platforms = lib.platforms.all;
  };
}
