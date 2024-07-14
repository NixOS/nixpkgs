{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "rfc3987";
  version = "1.3.8";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-08TSV6Vg1UTpgms4vIHbZ2iQx5q516ySs5x6JT1cpzM=";
  };

  doCheck = false;
  meta = with lib; {
    homepage = "https://pypi.python.org/pypi/rfc3987";
    license = licenses.gpl3Plus;
    description = "Parsing and validation of URIs (RFC 3986) and IRIs (RFC 3987)";
    maintainers = with maintainers; [ vanschelven ];
  };
}
