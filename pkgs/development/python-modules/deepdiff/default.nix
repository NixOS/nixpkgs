{ lib
, buildPythonPackage
, fetchPypi
, mock
, jsonpickle
, mmh3
, ordered-set
, numpy
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "deepdiff";
  version = "5.2.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ae2cb98353309f93fbfdda4d77adb08fb303314d836bb6eac3d02ed71a10b40e";
  };

  # # Extra packages (may not be necessary)
  checkInputs = [
    mock
    numpy
    pytestCheckHook
  ];

  propagatedBuildInputs = [
    jsonpickle
    mmh3
    ordered-set
  ];

  meta = with lib; {
    description = "Deep Difference and Search of any Python object/data";
    homepage = "https://github.com/seperman/deepdiff";
    license = licenses.mit;
    maintainers = [ maintainers.mic92 ];
  };
}
