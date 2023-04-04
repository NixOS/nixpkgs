{ buildPythonPackage, fetchPypi, lib }:
buildPythonPackage rec {
  pname = "Flor";
  name = pname;
  version = "1.1.3";

  meta = with lib; {
    description = "An efficient Bloom filter implementation in Python";
    platforms = platforms.all;
    homepage = "https://github.com/DCSO/flor";
    downloadPage = "https://github.com/DCSO/flor/releases";
    maintainers = with maintainers; [ jayrovacsek ];
    license = licenses.bsd3;
  };

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-H6wQHhYURtuy7lN51blQuwFf5tkFaDhaVJtTjKEv6UI=";
  };
}
