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
  version = "0.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c902e0653bcce927cc156a7fd9b3a51924cbce3bf3d0bfd49fc282bfd0c5dfd3";
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
