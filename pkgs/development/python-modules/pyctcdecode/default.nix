{
  buildPythonPackage,
  fetchPypi,
  unittestCheckHook,
  lib,
  numpy,
  pygtrie,
  kenlm,
}:

buildPythonPackage rec {
  pname = "pyctcdecode";
  version = "0.5.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-87yzE+Q8oWpUk4s+d7CzdTKGU7upMmaCQ9t0X95ROiw=";
  };

  propagatedBuildInputs = [
    numpy
    pygtrie
    kenlm
  ];

  nativeCheckInputs = [ unittestCheckHook ];

  meta = {
    description = "CTC beam search decoder for speech recognition";
    homepage = "https://github.com/kensho-technologies/pyctcdecode";
    maintainers = [ lib.maintainers.lucasew ];
    license = lib.licenses.asl20;
  };
}
