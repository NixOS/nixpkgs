{ stdenv
, buildPythonPackage
, fetchurl
}:

buildPythonPackage rec {
  pname = "distutils-extra";
  version = "2.39";

  src = fetchurl {
    url = "https://launchpad.net/python-distutils-extra/trunk/${version}/+download/python-${pname}-${version}.tar.gz";
    sha256 = "1bv3h2p9ffbzyddhi5sccsfwrm3i6yxzn0m06fdxkj2zsvs28gvj";
  };

  meta = with stdenv.lib; {
    homepage = https://launchpad.net/python-distutils-extra;
    description = "Enhancements to Python's distutils";
    license = licenses.gpl2;
  };

}
