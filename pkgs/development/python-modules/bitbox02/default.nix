{ stdenv
, buildPythonPackage
, hidapi
, noiseprotocol
, protobuf
, ecdsa
, semver
, typing-extensions
, base58
, pyserial
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "bitbox02";
  version = "2.0.3";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1mcbg7bvlsii1kj2mm5686z01pwcc36qbqlhz4a8syjrzjm6pl2k";
  };

  doCheck = false; # No tests present, which causes check phase to fail

  propagatedBuildInputs = [ hidapi noiseprotocol protobuf ecdsa semver typing-extensions base58 pyserial ];

  meta = with stdenv.lib; {
    description = "Communicate with your BitBox02 using Python";
    homepage = "https://github.com/digitalbitbox/bitbox02-firmware";
    license = licenses.asl20;
    maintainers = with maintainers; [ reardencode ];
  };
}
