{ lib
, fetchurl
, buildPythonPackage
, cryptography
, x21
, tomli
, pynacl
, rich
, requests
, tomli-w
, appdirs
, autoPatchelfHook
, gcc
}:

buildPythonPackage rec {
  pname = "kgt";
  version = "0.4.7";
  format = "wheel";

  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/c0/c5/23431d9198ff90ae8b57b84c4e12568fef5007fd614f8550529f609d8f10/kgt-0.4.7-py3-none-any.whl";
    sha256 = "sha256-HiNbecfle2CHJsh9m9UZfgahpcghnSv0BSVQ4hlJivY=";
  };

  propagatedBuildInputs = [
    appdirs
    cryptography
    pynacl
    requests
    rich
    tomli
    tomli-w
    x21
  ];

  pythonImportsCheck = [ "kgt" ];

  meta = with lib; {
    description = "Python tools for Keygen.sh licensing";
    homepage = "https://github.com/nschloe/kgt";
    # Unspecified license therefore unfree
    license = licenses.unfree;
    maintainers = with maintainers; [ onny ];
  };
}
