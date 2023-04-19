{ lib, stdenv, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonPackage rec {
  pname = "edl";
  version = "unstable-2022-09-07";

  src = fetchFromGitHub rec {
    owner = "bkerler";
    repo = "edl";
    rev = "f6b94da5faa003b48d24a5f4a8f0b8495626fd5b";
    fetchSubmodules = true;
    hash = "sha256-bxnRy+inWNArE2gUA/qDPy7NKvqBm43sbxdIaTc9N28=";
  };
  # edl has a spurious dependency on "usb" which has nothing to do with the
  # project and was probably added by accident trying to add pyusb
  postPatch = ''
    sed -i '/'usb'/d' setup.py
  '';
  # No tests set up
  doCheck = false;
  # EDL loaders are ELFs but shouldn't be touched, rest is Python anyways
  dontStrip = true;
  propagatedBuildInputs = with python3Packages; [
    pyusb
    pyserial
    docopt
    pylzma
    pycryptodome
    lxml
    colorama
    # usb
    capstone
    keystone-engine
  ];

  meta = with lib; {
    homepage = "https://github.com/bkerler/edl";
    description = "Qualcomm EDL tool (Sahara / Firehose / Diag)";
    license = licenses.mit;
    maintainers = with maintainers; [ lorenz ];
    # Case-sensitive files in 'Loader' submodule
    broken = stdenv.isDarwin;
  };
}

