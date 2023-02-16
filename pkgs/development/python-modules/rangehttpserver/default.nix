{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, nose
, requests
}:

buildPythonPackage rec {
  pname = "rangehttpserver";
  version = "1.2.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "danvk";
    repo = "RangeHTTPServer";
    rev = version;
    sha256 = "1sy9j6y8kp5jiwv2vd652v94kspp1yd4dwxrfqfn6zwnfyv2mzv5";
  };

  nativeBuildInputs = [
    setuptools
  ];

  nativeCheckInputs = [
    nose
    requests
  ];

  checkPhase = ''
    runHook preCheck
    nosetests
    runHook postCheck
  '';

  pythonImportsCheck = [
    "RangeHTTPServer"
  ];

  meta = with lib; {
    description = "SimpleHTTPServer with support for Range requests";
    homepage = "https://github.com/danvk/RangeHTTPServer";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
