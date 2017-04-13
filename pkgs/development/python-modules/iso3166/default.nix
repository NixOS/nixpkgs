{ stdenv, fetchurl, buildPythonPackage }:
 
buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "iso3166";
  version = "0.8";

  src = fetchurl {
    url = "mirror://pypi/i/${pname}/${name}.tar.gz";
    sha256 = "fbeb17bed90d15b1f6d6794aa2ea458e5e273a1d29b6f4939423c97640e14933";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/deactivated/python-iso3166;
    description = "Self-contained ISO 3166-1 country definitions";
    license = licenses.mit;
    maintainers = with maintainers; [ zraexy ];
  };
}
