{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
}:

buildPythonPackage rec {
  pname = "mbddns";
  version = "0.1.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "thinkl33t";
    repo = "mb-ddns";
    rev = version;
    sha256 = "13xzkprqk1v0zlzx4a0n9zzpnlb1g2h6pc62ms66fj72lsmjynj7";
  };

  propagatedBuildInputs = [ aiohttp ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "mbddns" ];

  meta = {
    description = "Mythic Beasts Dynamic DNS updater";
    homepage = "https://github.com/thinkl33t/mb-ddns";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
