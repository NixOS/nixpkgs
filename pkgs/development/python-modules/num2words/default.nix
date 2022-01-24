{ buildPythonPackage
, lib
, fetchPypi
, docopt
, delegator-py
, pytest
}:

buildPythonPackage rec {
  version = "0.5.10";
  pname = "num2words";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0myc27k087rhgpwn1a1dffzl32rwz6ngdbf3rm2i0zlgcxh4zk9p";
  };

  propagatedBuildInputs = [ docopt ];

  checkInputs = [ delegator-py pytest ];

  checkPhase = ''
    pytest -k 'not cli_with_lang'
  '';

  meta = with lib; {
    description = "Modules to convert numbers to words. 42 --> forty-two";
    homepage = "https://github.com/savoirfairelinux/num2words";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ jonringer ];

    longDescription =
    "num2words is a library that converts numbers like 42 to words like forty-two. It supports multiple languages (see the list below for full list of languages) and can even generate ordinal numbers like forty-second";
  };
}
