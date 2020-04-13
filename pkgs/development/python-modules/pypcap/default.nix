{ lib, writeText, buildPythonPackage, fetchPypi, libpcap, dpkt }:

buildPythonPackage rec {
  pname = "pypcap";
  version = "1.2.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1w5i79gh7cswvznr8rhilcmzhnh2y5c4jwh2qrfnpx05zqigm1xd";
  };

  patches = [
    # The default setup.py searchs for pcap.h in a static list of default
    # folders. So we have to add the path to libpcap in the nix-store.
    (writeText "libpcap-path.patch"
      ''
      --- a/setup.py
      +++ b/setup.py
      @@ -28,6 +28,7 @@ def recursive_search(path, target_files):

       def find_prefix_and_pcap_h():
           prefixes = chain.from_iterable((
      +        '${libpcap}',
               ('/usr', sys.prefix),
               glob.glob('/opt/libpcap*'),
               glob.glob('../libpcap*'),
      '')
  ];

  buildInputs = [ libpcap ];
  checkInputs = [ dpkt ];

  meta = with lib; {
    homepage = "https://github.com/pynetwork/pypcap";
    description = "Simplified object-oriented Python wrapper for libpcap";
    license = licenses.bsd3;
    maintainers = with maintainers; [ geistesk ];
  };
}
