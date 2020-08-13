{ lib, buildPythonPackage, fetchPypi
, alsaLib
}:

buildPythonPackage rec {
  pname = "rtmidi-python";
  version = "0.2.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1wpcaxfpbmsjc78g8841kpixr0a3v6zn0ak058s3mm25kcysp4m0";
  };

  buildInputs = [ alsaLib ];

  # package has no tests
  doCheck = false;

  pythonImportsCheck = [
    "rtmidi_python"
  ];

  meta = with lib; {
    description = "Python wrapper for RtMidi";
    homepage = "https://github.com/superquadratic/rtmidi-python";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
