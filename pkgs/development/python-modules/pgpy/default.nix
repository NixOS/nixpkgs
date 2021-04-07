{ lib, isPy3k, fetchFromGitHub, buildPythonPackage
, six, enum34, pyasn1, cryptography, singledispatch ? null
, fetchPypi, pytestCheckHook }:

buildPythonPackage rec {
  pname = "pgpy";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "SecurityInnovation";
    repo = "PGPy";
    rev = version;
    sha256 = "1v2b1dyq1sl48d2gw7vn4hv6sasd9ihpzzcq8yvxj9dgfak2y663";
  };

  propagatedBuildInputs = [
    six
    pyasn1
    cryptography
    singledispatch
  ] ++ lib.optional (!isPy3k) enum34;

  checkInputs = [
    pytestCheckHook
  ];

  disabledTests = [ "test_sign_string" "test_verify_string" ];

  meta = with lib; {
    homepage = "https://github.com/SecurityInnovation/PGPy";
    description = "Pretty Good Privacy for Python 2 and 3";
    longDescription = ''
      PGPy is a Python (2 and 3) library for implementing Pretty Good Privacy
      into Python programs, conforming to the OpenPGP specification per RFC
      4880.
    '';
    license = licenses.bsd3;
    maintainers = with maintainers; [ eadwu ];
  };
}
