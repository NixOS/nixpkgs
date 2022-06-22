{ lib
, fetchPypi
, buildPythonPackage
, setuptools-scm
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "makefun";
  version = "1.14.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-dwxuRY8e9HMEGFM08daG7iAXVdBhUqh44mRidTQMGB0=";
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
