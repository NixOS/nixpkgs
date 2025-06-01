{ mkDerivation, base, basement, bytestring, cereal, fetchgit, lib
, network
}:
mkDerivation {
  pname = "socks";
  version = "0.6.1";
  src = fetchgit {
    url = "https://github.com/simplex-chat/hs-socks";
    sha256 = "sha256-aEgouR5om+yElV5efcsLi+4plvq7qimrOTOkd7LdWnk=";
    rev = "a30cc7a79a08d8108316094f8f2f82a0c5e1ac51";
    fetchSubmodules = true;
  };
  libraryHaskellDepends = [
    base basement bytestring cereal network
  ];
  homepage = "http://github.com/vincenthz/hs-socks";
  description = "Socks proxy (ver 5)";
  license = lib.licenses.bsd3;
}
