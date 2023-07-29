{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, wheel
, nose
, parts
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "bitlist";
  version = "1.1.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-eViakuhgSe9E8ltxzeg8m6/ze7QQvoKBtYZoBZzHxlA=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'setuptools~=' 'setuptools>=' \
      --replace "--doctest-modules --ignore=docs --cov=bitlist --cov-report term-missing" ""
  '';

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    parts
  ];

  nativeCheckInputs = [
    pytestCheckHook
    nose
  ];

  pythonImportsCheck = [
    "bitlist"
  ];

  meta = with lib; {
    description = "Python library for working with little-endian list representation of bit strings";
    homepage = "https://github.com/lapets/bitlist";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
