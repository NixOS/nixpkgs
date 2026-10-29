{
  lib,
  buildPythonPackage,
  fetchurl,
  isPyPy,
  isPy3k,
}:

buildPythonPackage rec {
  version = "0.4.10";
  format = "setuptools";
  pname = "mmpython";

  src = fetchurl {
    url = "https://sourceforge.net/projects/mmpython/files/latest/download";
    hash = "sha256-HkbvFsGarGsOPDNdbj7tMEh0YFpBsneGnOpBPZpy+Kw=";
    name = "${pname}-${version}.tar.gz";
  };

  disabled = isPyPy || isPy3k;

  meta = {
    description = "Media Meta Data retrieval framework";
    homepage = "https://sourceforge.net/projects/mmpython/";
    license = lib.licenses.gpl2;
  };
}
