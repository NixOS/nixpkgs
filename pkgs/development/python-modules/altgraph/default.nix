{ lib, fetchPypi, python3Packages }:

python3Packages.buildPythonPackage rec {
  pname = "altgraph";
  version = "0.17";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-HwWkcSJUL5cCjK94d1oJX75qJpm1CJ3oR361gxZ9aao=";
  };

  meta = with lib; {
    description = "Python graph (network) package";
    homepage = "https://altgraph.readthedocs.io";
    license = licenses.mit;
    maintainers = with maintainers; [ kranzes ];
  };
}
