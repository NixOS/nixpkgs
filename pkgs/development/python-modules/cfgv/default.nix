{ lib, buildPythonPackage, fetchFromGitHub, isPy27, six }:

buildPythonPackage rec {
  pname = "cfgv";
  version = "3.3.1";
  disabled = isPy27;

  src = fetchFromGitHub {
     owner = "asottile";
     repo = "cfgv";
     rev = "v3.3.1";
     sha256 = "1pci97cmn3v45sfch9s3lshidrl0309ls9byidic0l8drkwnkwcj";
  };

  propagatedBuildInputs = [ six ];

  # Tests not included in PyPI tarball
  doCheck = false;

  meta = with lib; {
    description = "Validate configuration and produce human readable error messages";
    homepage = "https://github.com/asottile/cfgv";
    license = licenses.mit;
  };
}
