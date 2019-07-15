{ lib, fetchPypi, buildPythonPackage, warrant-ext, dnslib, pyaes, srp-ext, pyminifier, boto3, python-jose-ext, mock, requests, envs, future, pycryptodomex, ecdsa }:

buildPythonPackage rec {
  pname = "localstack-ext";
  version = "0.9.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "10n220n6d2gqvxf0jhvdrw2d5jkkwxvp6qfalgs1zqzxad22mmwl";
  };

  postPatch = ''
    substituteInPlace requirements.txt --replace "dnslib==0.9.7" "dnslib==0.9.10"
    substituteInPlace requirements.txt --replace "pyaes==1.6.0" "pyaes==1.6.1"
  '';

  buildInputs = [ warrant-ext dnslib pyaes srp-ext pyminifier boto3 python-jose-ext mock requests envs future pycryptodomex ecdsa ];

  doCheck = false;

  meta = {
    homepage = https://github.com/localstack/localstack;
    description = "extensions for localstack";
    maintainers = with lib.maintainers; [ mog ];
    license = lib.licenses.asl20;
  };
}
