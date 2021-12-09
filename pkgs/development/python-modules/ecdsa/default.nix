{ lib
, buildPythonPackage
, fetchFromGitHub
, pkgs
, six
}:

buildPythonPackage rec {
  pname = "ecdsa";
  version = "0.17.0";

  src = fetchFromGitHub {
     owner = "warner";
     repo = "python-ecdsa";
     rev = "python-ecdsa-0.17.0";
     sha256 = "1i8ykkf07q7s3aijbdxsybpclsxjkfj2pv2f2n8nf241n0wibsaz";
  };

  propagatedBuildInputs = [ six ];
  # Only needed for tests
  checkInputs = [ pkgs.openssl ];

  meta = with lib; {
    description = "ECDSA cryptographic signature library";
    homepage = "https://github.com/warner/python-ecdsa";
    license = licenses.mit;
  };

}
