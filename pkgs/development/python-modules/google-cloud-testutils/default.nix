{ stdenv, buildPythonPackage, fetchPypi, google-auth, six }:

buildPythonPackage rec {
  pname = "google-cloud-testutils";
  version = "0.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1bn1pz00lxym3vkl6l45b3nydpmfdvmylwggh2lspldrxwx39a0k";
  };

  propagatedBuildInputs = [ google-auth six ];

  # does not contain tests
  doCheck = false;

  pythonImportsCheck = [ "test_utils" ];

  meta = with stdenv.lib; {
    description = "System test utilities for google-cloud-python";
    homepage = "https://github.com/googleapis/python-test-utils";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
