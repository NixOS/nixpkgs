{
  lib,
  buildPythonPackage,
  fetchPypi,
  pdfrw,
}:

buildPythonPackage rec {
  pname = "pagelabels";
  version = "1.2.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "07as5kzyvj66bfgvx8bph8gkyj6cgm4lhgxwb78bpdl4m8y8kpma";
  };

  buildInputs = [ pdfrw ];

  # upstream doesn't contain tests
  doCheck = false;

  meta = with lib; {
    description = "Python library to manipulate PDF page labels";
    homepage = "https://github.com/lovasoa/pagelabels-py";
    maintainers = with maintainers; [ teto ];
    license = licenses.gpl3;
  };
}
