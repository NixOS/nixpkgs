{ lib
, buildPythonPackage
, fetchFromGitHub
, contexttimer
, versioneer
, cython
, numpy
, pytest
}:

buildPythonPackage rec {
  pname = "pyrevolve";
  version = "2.2.2";

  src = fetchFromGitHub {
    owner = "devitocodes";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-JLDn3WEBcdO8YYzt/MWOHB/1kcmbmZUsiH00/4Uwlxo=";
  };

  nativeBuildInputs = [ versioneer cython ];
  propagatedBuildInputs = [ contexttimer numpy ];

  nativeCheckInputs = [ pytest ];
  # Using approach bellow bcs the tests fail with the pytestCheckHook, throwing the following error
  # ImportError: cannot import name 'crevolve' from partially initialized module 'pyrevolve'
  # (most likely due to a circular import)
  checkPhase = ''
    pytest
  '';

  pythonImportsCheck = [ "pyrevolve" ];

  meta = with lib; {
    homepage = "https://github.com/devitocodes/pyrevolve";
    description = "Python library to manage checkpointing for adjoints";
    license = licenses.epl10;
    maintainers = with maintainers; [ atila ];
  };
}
