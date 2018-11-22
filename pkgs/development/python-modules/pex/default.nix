{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "pex";
  version = "1.2.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1m0gx9182w1dybkyjwwjyd6i87x2dzv252ks2fj8yn6avlcp5z4q";
  };

  prePatch = ''
    substituteInPlace setup.py --replace 'SETUPTOOLS_REQUIREMENT,' '"setuptools"'
  '';

  # A few more dependencies I don't want to handle right now...
  doCheck = false;

  meta = with stdenv.lib; {
    description = "A library and tool for generating .pex (Python EXecutable) files";
    homepage = "https://github.com/pantsbuild/pex";
    license = licenses.asl20;
    maintainers = with maintainers; [ copumpkin ];
  };

}
