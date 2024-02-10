{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
}:

buildPythonPackage rec {
  pname = "ptyprocess";
  version = "0.7.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5c5d0a3b48ceee0b48485e0c26037c0acd7d29765ca3fbb5cb3831d347423220";
  };

  patches = [
    # Remove after https://github.com/pexpect/ptyprocess/pull/64 is merged.
    (fetchpatch {
      url = "https://github.com/pexpect/ptyprocess/commit/40c1ccf3432a6787be1801ced721540e34c6cd87.patch";
      hash = "sha256-IemngBqBq3QRCmVscWtsuXHiFgvTOJIIB9SyAvsqHd0=";
    })
  ];

  meta = {
    description = "Run a subprocess in a pseudo terminal";
    homepage = "https://github.com/pexpect/ptyprocess";
    license = lib.licenses.isc;
  };
}
