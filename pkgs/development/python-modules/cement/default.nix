{ lib, buildPythonPackage, fetchPypi, isPy3k }:

buildPythonPackage rec {
  pname = "cement";
  version = "3.0.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fccec41eab3f15a03445b1ce24c8a7e106d4d5520f6507a7145698ce68923d31";
  };

  # Disable test tests since they depend on a memcached server running on
  # 127.0.0.1:11211.
  doCheck = false;

  disabled = !isPy3k;

  meta = with lib; {
    homepage = "https://builtoncement.com/";
    description = "A CLI Application Framework for Python.";
    maintainers = with maintainers; [ eqyiel ];
    license = licenses.bsd3;
  };
}
