{ stdenv
, buildPythonPackage
, fetchurl
}:

buildPythonPackage rec {
  version = "1.17.2"; # note: `conan` package may require a hardcoded one
  pname = "patch-ng";

  src = fetchurl {
    url = "mirror://pypi/p/${pname}/${pname}-${version}.tar.gz";
    sha256 = "02nadk70sk51liv0qav88kx8rzfdjc1x52023zayanz44kkcjl2i";
  };

  meta = with stdenv.lib; {
    description = "Library to parse and apply unified diffs.";
    homepage = "https://github.com/conan-io/python-patch";
    license = licenses.mit;
    maintainers = with maintainers; [ HaoZeke ];
  };

}
