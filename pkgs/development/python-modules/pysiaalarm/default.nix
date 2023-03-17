{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, dataclasses-json
, pycryptodome
, setuptools-scm
, pytest-asyncio
, pytest-cases
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pysiaalarm";
  version = "3.0.2";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-hS0OaafYjRdPVSCOHfb2zKp0tEOl1LyMJpwnpvsvALs=";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "==" ">="
    substituteInPlace pytest.ini \
      --replace "--cov pysiaalarm --cov-report term-missing" ""
  '';

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    dataclasses-json
    pycryptodome
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-cases
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pysiaalarm"
    "pysiaalarm.aio"
  ];

  meta = with lib; {
    description = "Python package for creating a client that talks with SIA-based alarm systems";
    homepage = "https://github.com/eavanvalkenburg/pysiaalarm";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
