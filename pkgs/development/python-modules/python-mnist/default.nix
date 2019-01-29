{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "python-mnist";
  version = "0.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5d59a44335eccb4b310efb2ebb76f44e8588a1732cfb4923f4a502b61d8b653a";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/sorki/python-mnist;
    description = "Simple MNIST data parser written in Python";
    license = licenses.bsd3;
    maintainers = with maintainers; [ cmcdragonkai ];
  };
}
