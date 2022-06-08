{ buildPythonPackage
, fetchPypi
, lib
, pytorch-bin
, einops
}:

buildPythonPackage rec {
  pname = "rotary-embedding-torch";
  version = "0.1.5";
  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-OgUvFk6fQtbbxZMWHZA6MwA8uRkP3GC3GbO7MflcjPY=";
  };
  propagatedBuildInputs = [
    pytorch-bin
    einops
  ];

  meta = with lib; {
    homepage = "https://github.com/lucidrains/rotary-embedding-torch";
    description = "Implementation of Rotary Embeddings, from the Roformer paper, in Pytorch";
    license = licenses.mit;
    maintainers = [ maintainers.ranfdev ];
  };
}
