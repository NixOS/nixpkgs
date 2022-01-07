{ lib
, fetchPypi
, buildPythonPackage
, setuptools-scm
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "makefun";
  version = "1.13.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2c673d2b4f0ef809347513cb45e3b23a04228588af7c9ac859e99247abac516a";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "pytest-runner" ""
  '';

  nativeBuildInputs = [
    setuptools-scm
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "makefun" ];

  meta = with lib; {
    homepage = "https://github.com/smarie/python-makefun";
    description = "Small library to dynamically create python functions";
    license = licenses.bsd2;
    maintainers = with maintainers; [ veehaitch ];
  };
}
