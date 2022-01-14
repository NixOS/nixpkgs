{ lib
, fetchPypi
, buildPythonPackage
, setuptools-scm
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "makefun";
  version = "1.13.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "985bb8b670ffbbb95d2a8aa996d318e6e9a3f26fc6f3ef2da93ebdf8f9c616bf";
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
