{
  lib,
  buildPythonPackage,
  fetchPypi,
  fetchpatch,
  sh,
}:

buildPythonPackage rec {
  pname = "python-packer";
  version = "0.1.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-/TY9rpvS79RHc5u/ek8pweR0FZauewLSUv5SWytBduc=";
  };

  patches = fetchpatch {
    url = "${meta.homepage}/commit/de3421bf13bf7c3ec11fe0a381f0944e102b1d97.patch";
    excludes = [ "dev-requirements.txt" ];
    sha256 = "0rgmkyn7i6y1xs8m75dpl8hq7j2ns2s3dvp7kv9j4zwic93rrlsc";
  };

  propagatedBuildInputs = [ sh ];

  # Tests requires network connections
  doCheck = false;

  meta = with lib; {
    description = "Interface for packer.io";
    homepage = "https://github.com/nir0s/python-packer";
    license = licenses.asl20;
    maintainers = with maintainers; [ psyanticy ];
  };
}
