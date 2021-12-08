{ lib
, buildPythonPackage
, fetchFromGitHub
}:

buildPythonPackage rec {
  version = "0.6.0";
  pname = "BespON";

  src = fetchFromGitHub {
     owner = "gpoore";
     repo = "bespon_py";
     rev = "v0.6.0";
     sha256 = "0x1ifklhh88fa6i693zgpb63646jxsyhj4j64lrvarckrb31wk23";
  };

  propagatedBuildInputs = [ ];
  # upstream doesn't contain tests
  doCheck = false;

  pythonImportsCheck = [ "bespon" ];
  meta = with lib; {
    description = "Encodes and decodes data in the BespON format.";
    homepage = "https://github.com/gpoore/bespon_py";
    license = licenses.bsd3;
    maintainers = with maintainers; [ synthetica ];
  };

}
