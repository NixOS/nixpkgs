{ lib
, buildPythonPackage
, dpkt
, fetchFromGitHub
, libpcap
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pypcap";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "pynetwork";
    repo = pname;
    # No release was tagged and PyPI doesn't contain tests.
    rev = "968859f0ffb5b7c990506dffe82457b7de23a026";
    sha256 = "sha256-NfyEC3qEBm6TjebcDIsoz8tJWaJ625ZFPfx7AMyynWE=";
  };

  postPatch = ''
    # Add the path to libpcap in the nix-store
    substituteInPlace setup.py --replace "('/usr', sys.prefix)" "'${libpcap}'"
    # Remove coverage from test run
    sed -i "/--cov/d" setup.cfg
  '';

  buildInputs = [ libpcap ];

  checkInputs = [
    dpkt
    pytestCheckHook
  ];

  pytestFlagsArray = [ "tests" ];

  pythonImportsCheck = [ "pcap" ];

  meta = with lib; {
    homepage = "https://github.com/pynetwork/pypcap";
    description = "Simplified object-oriented Python wrapper for libpcap";
    license = licenses.bsd3;
    maintainers = with maintainers; [ oxzi ];
  };
}
