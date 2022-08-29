{ lib
, buildPythonPackage
, fetchPypi
, nose
, parts
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "bitlist";
  version = "1.0.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-rpXQKkV2RUuYza+gfpGEH3kFJ+hjuNGKV2i46eXQUUI=";
  };

  propagatedBuildInputs = [
    parts
  ];

  checkInputs = [
    pytestCheckHook
    nose
  ];

  pythonImportsCheck = [
    "bitlist"
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "--doctest-modules --ignore=docs --cov=bitlist --cov-report term-missing" ""
  '';

  meta = with lib; {
    description = "Python library for working with little-endian list representation of bit strings";
    homepage = "https://github.com/lapets/bitlist";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
