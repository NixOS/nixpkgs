{ buildPythonPackage, fetchPypi, lib }:

buildPythonPackage rec {
  pname = "Flor";

  version = "1.1.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-H6wQHhYURtuy7lN51blQuwFf5tkFaDhaVJtTjKEv6UI=";
  };

  meta = with lib; {
    description = "An efficient Bloom filter implementation in Python";
    downloadPage = "https://github.com/DCSO/flor/releases";
    homepage = "https://github.com/DCSO/flor";
    license = licenses.bsd3;
    maintainers = [ maintainers.jayrovacsek ];
    platforms = platforms.unix;
  };
}
