{ buildPythonPackage
, lib
, fetchPypi
, docopt
, delegator-py
, pytest
}:

buildPythonPackage rec {
  version = "0.5.12";
  pname = "num2words";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-fnwLDwgEBao6HdnTKxypCzvwO6sXuOVNsF4beDAaCYg=";
  };

  propagatedBuildInputs = [ docopt ];

  nativeCheckInputs = [ delegator-py pytest ];

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
