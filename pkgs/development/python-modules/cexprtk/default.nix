{ lib
, fetchPypi
, buildPythonPackage
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "cexprtk";
  version = "0.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-c7QXB+oXzkRveiPpNrW/HY8pMtpZx/RtDpJMVE7fY/A=";
  };

  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "cexprtk" ];

  meta = with lib; {
    description = "Mathematical expression parser, cython wrapper";
    homepage = "https://github.com/mjdrushton/cexprtk";
    license = licenses.cpl10;
    maintainers = with maintainers; [ onny ];
  };
}
