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
    sha256 = "1mzc29wwyhyardclj1vg2xsfdibg2lzb7f1azjcxi580ama55wv2";
  };

  propagatedNativeBuildInputs = [ cffi ];

  propagatedBuildInputs = [ cffi ];

  # The tests require write access to $out
  doCheck = false;

<<<<<<< HEAD
  meta = {
    description = "CFFI binding for Hoedown, a markdown parsing library";
    mainProgram = "misaka";
    homepage = "https://misaka.61924.nl";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fgaz ];
=======
  meta = with lib; {
    description = "CFFI binding for Hoedown, a markdown parsing library";
    mainProgram = "misaka";
    homepage = "https://misaka.61924.nl";
    license = licenses.mit;
    maintainers = with maintainers; [ fgaz ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
