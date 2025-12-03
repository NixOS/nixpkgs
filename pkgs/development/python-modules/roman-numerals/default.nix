{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  flit-core,
  pytestCheckHook,
  sphinx,
}:

buildPythonPackage rec {
  pname = "roman-numerals";
  version = "3.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "AA-Turner";
    repo = "roman-numerals";
    tag = "v${version}";
    hash = "sha256-YLF09jYwXq48iMvmqbj/cocYJPp7RsCXzbN0DV9gpis=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/AA-Turner/roman-numerals/commit/cc8ec3aca53c9246965500f8fc14aee636fd5307.patch";
      hash = "sha256-zSnJ3DP0hdwhKkFzPWZGJNn1OzwLBF3W8Q6KzwX4Ap4=";
    })
  ];

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
    platforms = lib.platforms.all;
  };
}
