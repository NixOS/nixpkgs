{ lib
, buildPythonPackage
, dpkt
, fetchFromGitHub
, fetchpatch
, libpcap
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pypcap";
  version = "1.2.3";


  src = fetchFromGitHub {
    owner = "pynetwork";
    repo = pname;
    rev = "v${version}";
    sha256 = "1zscfk10jpqwxgc8d84y8bffiwr92qrg2b24afhjwiyr352l67cf";
  };

  patches = [
    # Support for Python 3.9, https://github.com/pynetwork/pypcap/pull/102
    (fetchpatch {
      name = "support-python-3.9.patch";
      url = "https://github.com/pynetwork/pypcap/pull/102/commits/e22f5d25f0d581d19ef337493434e72cd3a6ae71.patch";
      sha256 = "0n1syh1vcplgsf6njincpqphd2w030s3b2jyg86d7kbqv1w5wk0l";
    })
  ];

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
