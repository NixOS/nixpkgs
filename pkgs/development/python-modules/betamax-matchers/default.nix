{ lib, buildPythonPackage, fetchFromGitHub
, betamax, requests-toolbelt }:

buildPythonPackage rec {
  pname = "betamax-matchers";
  version = "0.4.0";

  src = fetchFromGitHub {
     owner = "sigmavirus24";
     repo = "betamax_matchers";
     rev = "0.4.0";
     sha256 = "0lyg3r91hwfvavyi5k6sddcla37igigycfv1mx40c32byqwl6pq5";
  };

  buildInputs = [ betamax requests-toolbelt ];

  meta = with lib; {
    homepage = "https://github.com/sigmavirus24/betamax_matchers";
    description = "A group of experimental matchers for Betamax";
    license = licenses.asl20;
    maintainers = with maintainers; [ pSub ];
  };
}
