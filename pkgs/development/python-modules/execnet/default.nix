{ lib
, buildPythonPackage
, isPyPy
, fetchPypi
, fetchpatch
, pytestCheckHook
, setuptools-scm
, apipkg
, py
}:

buildPythonPackage rec {
  pname = "execnet";
  version = "1.9.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8f694f3ba9cc92cab508b152dcfe322153975c29bda272e2fd7f3f00f36e47c5";
  };

  patches = [
    (fetchpatch {
      # Fix test compat with pytest 7.2.0
      url = "https://github.com/pytest-dev/execnet/commit/c0459b92bc4a42b08281e69b8802d24c5d3415d4.patch";
      hash = "sha256-AT2qr7AUpFXcPps525U63A7ARcEVmf0HM6ya73Z2vi0=";
    })
  ];

  postPatch = ''
    # remove vbox tests
    rm testing/test_termination.py
    rm testing/test_channel.py
    rm testing/test_xspec.py
    rm testing/test_gateway.py
  '' + lib.optionalString isPyPy ''
    rm testing/test_multi.py
  '';

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    apipkg
  ];

  # sometimes crashes with: OSError: [Errno 9] Bad file descriptor
  doCheck = !isPyPy;

  nativeCheckInputs = [
    py # no longer required with 1.10.0
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "execnet"
  ];

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    changelog = "https://github.com/pytest-dev/execnet/blob/v${version}/CHANGELOG.rst";
    description = "Distributed Python deployment and communication";
    homepage = "https://execnet.readthedocs.io/";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
