{
  lib,
  buildPythonPackage,
  fetchPypi,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "opnieuw";
  version = "3.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-BxhSz+AsL7lU3zw9tIL2R+Pxktb8NG2/UKPtEDJT+Qo=";
  };

  propagatedBuildInputs = [ typing-extensions ];

  meta = with lib; {
    description = "Python retrying library: One weird trick to make your code more reliable";
    homepage = "https://github.com/channable/opnieuw";
    license = licenses.bsd3;
    maintainers = with maintainers; [
      duijf
      arianvp
    ];
  };
}
