{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
, setuptools
, wheel
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

  patches = [
    # https://github.com/lapets/bitlist/pull/1
    (fetchpatch {
      name = "unpin-setuptools-dependency.patch";
      url = "https://github.com/lapets/bitlist/commit/d1f977a9e835852df358b2d93b642a6820619c10.patch";
      hash = "sha256-BBa6gdhuYsWahtp+Qdp/RigmVHK+uWyK46M1CdD8O2g=";
    })
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace '--cov=bitlist --cov-report term-missing' ""
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
