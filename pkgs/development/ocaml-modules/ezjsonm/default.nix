{ stdenv, fetchzip, buildDunePackage, jsonm, hex, sexplib }:

buildDunePackage rec {
  pname = "ezjsonm";
  version = "0.6.0";

  src = fetchzip {
    url = "https://github.com/mirage/${pname}/archive/${version}.tar.gz";
    sha256 = "18g64lhai0bz65b9fil12vlgfpwa9b5apj7x6d7n4zzm18qfazvj";
  };

  propagatedBuildInputs = [ jsonm hex sexplib ];

  meta = {
    description = "An easy interface on top of the Jsonm library";
    homepage = "https://github.com/mirage/ezjsonm";
    license = stdenv.lib.licenses.isc;
    maintainers = with stdenv.lib.maintainers; [ vbgl ];
  };
}
