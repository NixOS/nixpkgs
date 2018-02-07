{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "affinity";
  version = "0.1.0";
  src = fetchPypi {
    inherit pname version;
    sha256 = "1i6j7kszvnzh5vh9k48cqwx2kzf73a6abgv9s6bf0j2zmfjl2wb6";
  };
  meta = {
    description = "control processor affinity on windows and linux";
    homepage    = http://cheeseshop.python.org/pypi/affinity;
    license     = with lib.licenses; [ psfl ];
  };
}
