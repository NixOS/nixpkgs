{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "pex";
  version = "1.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0kfdhzb9srnvr7d2i91xqi945z6gcf51800a96bxld99r69i3zbv";
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
