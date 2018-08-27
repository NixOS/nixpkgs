{lib, buildPythonPackage, fetchPypi}:

buildPythonPackage rec {
  name = "pex-${version}";
  version = "1.2.7";

  src = fetchPypi {
    pname  = "pex";
    sha256 = "1m0gx9182w1dybkyjwwjyd6i87x2dzv252ks2fj8yn6avlcp5z4q";
    inherit version;
  };

  prePatch = ''
    substituteInPlace setup.py --replace 'SETUPTOOLS_REQUIREMENT,' '"setuptools"'
  '';

  # A few more dependencies I don't want to handle right now...
  doCheck = false;

  meta = {
    description = "A library and tool for generating .pex (Python EXecutable) files";
    homepage = "https://github.com/pantsbuild/pex";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ copumpkin ];
  };
}
