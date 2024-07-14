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
    hash = "sha256-/40raFX2YM0jzV7Hm9ECZNOfJPYjV3MzG0jn/NY31sw=";
  };

  postPatch = ''
    # python 3.12 compatibility
    substituteInPlace tests/*.py \
      --replace "assertEquals" "assertEqual" \
      --replace "assertNotEquals" "assertNotEqual" \
      --replace "assert_equals" "assert_equal"
  '';

  meta = with lib; {
    description = "Mocking, stubbing and spying framework for python";
  };
}
