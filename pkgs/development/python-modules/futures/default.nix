{ lib, buildPythonPackage, fetchPypi, isPy3k, python, stdenv }:

buildPythonPackage rec {
  pname = "futures";
  version = "3.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9ec02aa7d674acb8618afb127e27fde7fc68994c0437ad759fa094a574adb265";
  };

  # This module is for backporting functionality to Python 2.x, it's builtin in py3k
  disabled = isPy3k;

  checkPhase = ''
    ${python.interpreter} test_futures.py
  '';

  doCheck = !stdenv.isDarwin;

  meta = with lib; {
    description = "Backport of the concurrent.futures package from Python 3.2";
    homepage = "https://github.com/agronholm/pythonfutures";
    license = licenses.bsd2;
    maintainers = with maintainers; [  ];
  };
}
