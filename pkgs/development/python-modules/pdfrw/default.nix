{ lib, buildPythonPackage, fetchPypi}:

buildPythonPackage rec {
  pname = "pdfrw";
  version = "0.4";
  
  src = fetchPypi {
    inherit pname version;
    sha256 = "0dc0494a0e6561b268542b28ede2280387c2728114f117d3bb5d8e4787b93ef4";
  };

  # Testing depends on external resources, not included in the package
  doCheck = false;
  
  meta = with lib; {
    description = "PDF file reader/writer library";
    homepage = "https://github.com/pmaupin/pdfrw";
    license = licenses.mit;
    maintainers = [ maintainers.arnoldfarkas ];
  };
}
