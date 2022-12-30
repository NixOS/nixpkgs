{ lib
, buildPythonPackage
, fetchPypi
, six
, attrs
, pytestCheckHook
, hypothesis
, pretend
, arpeggio
}:

buildPythonPackage rec {
  pname = "parver";
  version = "0.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-1KPbuTxTNz7poLoFXkhYxEFpsgS5EuSdAD6tlduam8o=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "arpeggio ~= 1.7" "arpeggio"
  '';

  propagatedBuildInputs = [
    six
    attrs
    arpeggio
  ];

  checkInputs = [
    pytestCheckHook
    hypothesis
    pretend
  ];

  meta = with lib; {
    description = "Allows parsing and manipulation of PEP 440 version numbers";
    homepage = "https://github.com/RazerM/parver";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
