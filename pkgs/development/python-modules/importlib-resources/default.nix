{ lib
, buildPythonPackage
, fetchPypi
, pathlib2
, typing
, isPy3k
, pythonOlder
}:

buildPythonPackage rec {
  pname = "importlib_resources";
  version = "1.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d3279fd0f6f847cced9f7acc19bd3e5df54d34f93a2e7bb5f238f81545787078";
  };

  propagatedBuildInputs = [
  ] ++ lib.optional (!isPy3k) pathlib2
    ++ lib.optional (pythonOlder "3.5") typing
  ;

  # https://gitlab.com/python-devs/importlib_resources/issues/69
  doCheck = !isPy3k;

  meta = with lib; {
    description = "Read resources from Python packages";
    homepage = https://importlib-resources.readthedocs.io/;
    license = licenses.asl20;
  };
}