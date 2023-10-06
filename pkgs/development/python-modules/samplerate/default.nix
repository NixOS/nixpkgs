{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, cffi
, numpy
, libsamplerate
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "samplerate";
  version = "0.1.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "tuxu";
    repo = "python-samplerate";
    rev = "refs/tags/${version}";
    hash = "sha256-lHZ9SVnKcsEsnKYXR/QocGbKPEoA7yCZxXvrNPeH1rA=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace ", 'pytest-runner'" ""

    substituteInPlace samplerate/lowlevel.py --replace \
      "lib_filename = _find_library('samplerate')" \
      'lib_filename = "${libsamplerate.out}/lib/libsamplerate${stdenv.hostPlatform.extensions.sharedLibrary}"'
  '';

  propagatedBuildInputs = [
    cffi
    numpy
  ];

  pythonImportsCheck = [
    "samplerate"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  preCheck = ''
    rm -rf samplerate
  '';

  meta = with lib; {
    description = "Python bindings for libsamplerate based on CFFI and NumPy";
    homepage = "https://github.com/tuxu/python-samplerate";
    changelog = "https://github.com/tuxu/python-samplerate/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
