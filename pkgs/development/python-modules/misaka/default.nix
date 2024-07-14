{
  lib,
  fetchPypi,
  buildPythonPackage,
  cffi,
}:
buildPythonPackage rec {
  pname = "misaka";
  version = "2.1.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-YvNSVFUAldiZ/Cq4sz4Vb8XmdBdvB0lZy8pDz3kS7Nc=";
  };

  propagatedNativeBuildInputs = [ cffi ];

  propagatedBuildInputs = [ cffi ];

  # The tests require write access to $out
  doCheck = false;

  meta = with lib; {
    description = "CFFI binding for Hoedown, a markdown parsing library";
    mainProgram = "misaka";
    homepage = "https://misaka.61924.nl";
    license = licenses.mit;
    maintainers = with maintainers; [ fgaz ];
  };
}
