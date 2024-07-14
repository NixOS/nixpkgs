{
  lib,
  buildPythonPackage,
  fetchPypi,
  pyyaml,
}:

buildPythonPackage rec {
  pname = "aspy-yaml";
  version = "1.3.0";
  format = "setuptools";

  src = fetchPypi {
    pname = "aspy.yaml";
    inherit version;
    hash = "sha256-58dCOC7/LK7WH4ejnRP5kQkIjl6T8E12641LKKoUP0U=";
  };

  propagatedBuildInputs = [ pyyaml ];

  # Tests not included in PyPI tarball
  doCheck = false;

  meta = with lib; {
    description = "Few extensions to pyyaml";
    homepage = "https://github.com/asottile/aspy.yaml";
    license = licenses.mit;
  };
}
