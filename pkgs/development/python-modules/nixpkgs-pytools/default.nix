{ lib
, buildPythonPackage
, fetchPypi
, jinja2
, setuptools
, isPy27
}:

buildPythonPackage rec {
  pname = "nixpkgs-pytools";
  version = "1.0.1";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0796c6e95daeb3d7e61c9c53126d95ba6a48f84b995b12b60f45619caf28a574";
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
