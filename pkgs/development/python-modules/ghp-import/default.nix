{ buildPythonPackage
, dateutil
, fetchPypi
, lib
}:

buildPythonPackage rec {
  pname = "ghp-import";
  version = "1.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "wiqc4Qw3dT4miNFk12WnANrkuNefptsKLDEyuniBiU8=";
  };

  pythonImportsCheck = [ "ghp_import" ];

  propagatedBuildInputs = [ dateutil ];

  meta = with lib; {
    description = "Copy your docs directly to the gh-pages branch";
    homepage = "https://github.com/c-w/ghp-import";
    license = licenses.asl20;
    maintainers = with maintainers; [ veehaitch ];
  };
}
