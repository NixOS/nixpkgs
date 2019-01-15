{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "pex";
  version = "1.5.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a0244c9e25172598fca73cb61e2a2f133503565c95d99210c3d5c0e85950c4bd";
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
