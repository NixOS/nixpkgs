{ lib, buildPythonPackage, fetchPypi, isPy3k, python }:

buildPythonPackage rec {
  pname = "futures";
  version = "3.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1z9j05fdj2yszjmz4pmjhl2jdnwhdw80cjwfqq3ci0yx19gv9v2i";
  };

  # This module is for backporting functionality to Python 2.x, it's builtin in py3k
  disabled = isPy3k;

  checkPhase = ''
    ${python.interpreter} -m unittest discover
  '';

  # Tests fail
  doCheck = false;

  meta = with lib; {
    description = "Backport of the concurrent.futures package from Python 3.2";
    homepage = "https://github.com/agronholm/pythonfutures";
    license = licenses.bsd2;
    maintainers = with maintainers; [ garbas ];
  };
}
