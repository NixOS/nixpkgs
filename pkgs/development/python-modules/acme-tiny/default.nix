{ stdenv, buildPythonPackage, fetchFromGitHub
, python, openssl }:

buildPythonPackage rec {
  pname = "acme-tiny";
  version = "2016-03-26";
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    sha256 = "0ngmr3kxcvlqa9mrv3gx0rg4r67xvdjplqfminxliri3ipak853g";
    rev = "7a5a2558c8d6e5ab2a59b9fec9633d9e63127971";
    repo = "acme-tiny";
    owner = "diafygi";
  };

  # source doesn't have any python "packaging" as such
  configurePhase = " ";
  buildPhase = " ";
  # the tests are... complex
  doCheck = false;

  patchPhase = ''
    substituteInPlace acme_tiny.py --replace "openssl" "${openssl.bin}/bin/openssl"
  '';

  installPhase = ''
    mkdir -p $out/${python.sitePackages}/
    cp acme_tiny.py $out/${python.sitePackages}/
    mkdir -p $out/bin
    ln -s $out/${python.sitePackages}/acme_tiny.py $out/bin/acme_tiny
    chmod +x $out/bin/acme_tiny
  '';

  meta = with stdenv.lib; {
    description = "A tiny script to issue and renew TLS certs from Let's Encrypt";
    homepage = https://github.com/diafygi/acme-tiny;
    license = licenses.mit;
  };
}
