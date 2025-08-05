{
  lib,
  buildPythonPackage,
  fetchPypi,
  six,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "retrying";
  version = "1.4.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-0QLnXVPY0wuIVi1FNh1sbJNNoG+rMb2BwEIKy5eoujk=";
  };

  propagatedBuildInputs = [ six ];

  # doesn't ship tests in tarball
  doCheck = false;

  pythonImportsCheck = [ "retrying" ];

  meta = with lib; {
    description = "General-purpose retrying library";
    homepage = "https://github.com/rholder/retrying";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
