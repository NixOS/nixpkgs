{ lib
, buildPythonPackage
, fetchPypi
, pythonAtLeast
}:

buildPythonPackage rec {
  pname = "aioprocessing";
  version = "1.0.1";
  disabled = !(pythonAtLeast "3.4");

  src = fetchPypi {
    inherit pname version;
    sha256 = "1yq1gfsky2kjimwdmzqk893sp6387vbl4bw0sbha5hl6cm3jp5dn";
  };

  # Tests aren't included in pypi package
  doCheck = false;

  meta = {
    description = "A library that integrates the multiprocessing module with asyncio";
    homepage = https://github.com/dano/aioprocessing;
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ uskudnik ];
  };
}
