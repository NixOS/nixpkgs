{ lib
, buildPythonPackage
, fetchPypi
, jinja2
, setuptools
, isPy27
}:

buildPythonPackage rec {
  pname = "nixpkgs-pytools";
  version = "1.0.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "6aaf1e990be639a0d01afb454756606f3111dd8c596b6e848d4a0cec019168d0";
  };

  propagatedBuildInputs = [
    jinja2
    setuptools
  ];

  # tests require network ..
  doCheck = false;

  meta = with lib; {
    description = "Tools for removing the tedious nature of creating nixpkgs derivations";
    homepage = https://github.com/nix-community/nixpkgs-pytools;
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
