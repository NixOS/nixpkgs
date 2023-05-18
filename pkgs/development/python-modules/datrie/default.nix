{ lib
, buildPythonPackage
, fetchPypi
, cython
, pytestCheckHook
, hypothesis
}:

buildPythonPackage rec {
  pname = "datrie";
  version = "0.8.2";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-UlsI9jjVz2EV32zNgY5aASmM0jCy2skcj/LmSZ0Ydl0=";
  };

  nativeBuildInputs = [
    cython
  ];

  buildInputs = [
    hypothesis
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace setup.py --replace '"pytest-runner", ' ""
  '';

  pythonImportsCheck = [ "datrie" ];

  meta = with lib; {
    description = "Super-fast, efficiently stored Trie for Python";
    homepage = "https://github.com/kmike/datrie";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ lewo ];
  };
}
