{ buildPythonPackage
, fetchPypi
, isPy27
, lib
, morphys
, pytest
, pytestrunner
, python-baseconv
, six
}:
buildPythonPackage rec {
  pname = "py-multibase";
  version = "1.0.1";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version ;
    sha256 = "6ed706ea321b487ba82e4172a9c82d61dacd675c865f576a937a94bca1a23443";
  };

  postPatch = ''
    substituteInPlace setup.cfg --replace "[pytest]" ""
    substituteInPlace setup.cfg --replace "python_classes = *TestCase" ""
  '';

  nativeBuildInputs = [
    pytestrunner
  ];

  propagatedBuildInputs = [
    morphys
    six
    python-baseconv
  ];

  checkInputs = [
    pytest
  ];

  meta = with lib; {
    description = "Multibase is a protocol for distinguishing base encodings and other simple string encodings";
    homepage = "https://github.com/multiformats/py-multibase";
    license = licenses.mit;
    maintainers = with maintainers; [ rakesh4g ];
  };
}