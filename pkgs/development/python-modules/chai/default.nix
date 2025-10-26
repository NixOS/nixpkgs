{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "chai";
  version = "1.1.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ff8d2b6855f660cd23cd5ec79bd10264d39f24f6235773331b48e7fcd637d6cc";
  };

  postPatch = ''
    # python 3.12 compatibility
    substituteInPlace tests/*.py \
      --replace "assertEquals" "assertEqual" \
      --replace "assertNotEquals" "assertNotEqual" \
      --replace "assert_equals" "assert_equal"
  '';

  meta = {
    description = "Mocking, stubbing and spying framework for python";
  };
}
