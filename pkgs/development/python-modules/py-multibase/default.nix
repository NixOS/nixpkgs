{ buildPythonPackage
, fetchPypi
, isPy27
, lib
, morphys
, pytest
, pytest-runner
, python-baseconv
, six
}:
buildPythonPackage rec {
  pname = "py-multibase";
  version = "1.0.3";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version ;
    sha256 = "d28a20efcbb61eec28f55827a0bf329c7cea80fffd933aecaea6ae8431267fe4";
  };

  postPatch = ''
    substituteInPlace setup.cfg --replace "[pytest]" ""
    substituteInPlace setup.cfg --replace "python_classes = *TestCase" ""
  '';

  nativeBuildInputs = [
    pytest-runner
  ];

  propagatedBuildInputs = [
    morphys
    six
    python-baseconv
  ];

  nativeCheckInputs = [
    pytest
  ];

  meta = with lib; {
    description = "Multibase is a protocol for distinguishing base encodings and other simple string encodings";
    homepage = "https://github.com/multiformats/py-multibase";
    license = licenses.mit;
    maintainers = with maintainers; [ rakesh4g ];
  };
}
