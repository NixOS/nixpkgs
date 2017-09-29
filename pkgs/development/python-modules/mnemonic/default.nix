{ lib, fetchurl, buildPythonPackage, pbkdf2 }:

buildPythonPackage rec {
  pname = "mnemonic";
  version = "0.17";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://pypi/m/${pname}/${name}.tar.gz";
    sha256 = "1hq6xb47jagfqf65iwcrh0065mj3521d2mxmahg7vfraihqyqdjn";
  };

  propagatedBuildInputs = [ pbkdf2 ];

  meta = {
    description = "Implementation of Bitcoin BIP-0039";
    homepage = https://github.com/trezor/python-mnemonic;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ np ];
  };
}
