{ pkgs
, buildPythonPackage
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "escapism";
  version = "1.0.1";

  src = fetchFromGitHub {
     owner = "minrk";
     repo = "escapism";
     rev = "1.0.1";
     sha256 = "1447mamrdbyv9v47f9wrc4fyvbwz5qrwl8qrdzqdq3q62q4xrawj";
  };

  # No tests distributed
  doCheck = false;

  meta = with pkgs.lib; {
    description = "Simple, generic API for escaping strings";
    homepage = "https://github.com/minrk/escapism";
    license = licenses.mit;
    maintainers = with maintainers; [ bzizou ];
  };
}
