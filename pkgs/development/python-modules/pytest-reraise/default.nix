{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, poetry-core
}:

buildPythonPackage rec {
  pname = "pytest-reraise";
  version = "2.1.2";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "bjoluc";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-mgNKoZ+2sinArTZhSwhLxzBTb4QfiT1LWBs7w5MHXWA=";
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pytest_reraise" ];

  checkInputs = [
    poetry-core
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "poetry.masonry.api" "poetry.core.masonry.api"
  '';


  meta = with lib; {
    description = "";
    homepage = "";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ qbit ];
  };
}
