{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "ppdeep";
  version = "20250622";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-QKEcNp8B+K5eE+2DOvfkMMIl9Y+gS3dlGqSWgeQe1Gw=";
  };

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [ "ppdeep" ];

  meta = with lib; {
    description = "Python library for computing fuzzy hashes (ssdeep)";
    homepage = "https://github.com/elceef/ppdeep";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
