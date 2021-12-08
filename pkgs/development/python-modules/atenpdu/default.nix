{ lib
, buildPythonPackage
, fetchFromGitHub
, pysnmp
}:

buildPythonPackage rec {
  pname = "atenpdu";
  version = "0.3.2";

  src = fetchFromGitHub {
     owner = "mtdcr";
     repo = "pductl";
     rev = "0.3.2";
     sha256 = "0l59za3qfpq75d8iikd92p8v8vwia29zlpzs15h571kl83z9qj1i";
  };

  propagatedBuildInputs = [ pysnmp ];

  # Project has no test
  doCheck = false;
  pythonImportsCheck = [ "atenpdu" ];

  meta = with lib; {
    description = "Python interface to control ATEN PE PDUs";
    homepage = "https://github.com/mtdcr/pductl";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
