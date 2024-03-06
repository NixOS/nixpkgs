{ lib
, buildPythonPackage
, fetchFromGitHub
, cu2qu
, defcon
, fontfeatures
, fonttools
, glyphslib
, openstep-plist
, orjson
, poetry-core
, pytestCheckHook
, ufolib2
}:

buildPythonPackage rec {
  pname = "babelfont";
  version = "3.0.1";

  # PyPI source tarballs omit tests, fetch from Github instead
  src = fetchFromGitHub {
    owner = "simoncozens";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-1DHcJDVaCgIAODyf5UUrXej8x3ySD4+6/KtxuF2yFV4=";
  };

  pyproject = true;

  propagatedBuildInputs = [
    cu2qu
    fontfeatures
    fonttools
    glyphslib
    openstep-plist
    orjson
    ufolib2
  ];
  nativeBuildInputs = [
    poetry-core
  ];

  doCheck = true;
  nativeCheckInputs = [
    defcon
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Python library to load, examine, and save fonts in a variety of formats";
    homepage = "https://github.com/simoncozens/babelfont";
    license = licenses.bsd3;
    maintainers = with maintainers; [ danc86 ];
  };
}
