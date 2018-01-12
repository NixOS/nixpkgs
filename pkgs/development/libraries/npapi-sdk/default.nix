{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "npapi-sdk-${version}";

  version = "0.27.2";

  src = fetchurl {
    url = "https://bitbucket.org/mgorny/npapi-sdk/downloads/${name}.tar.bz2";

    sha256 = "0xxfcsjmmgbbyl9zwpzdshbx27grj5fnzjfmldmm9apws2yk9gq1";
  };

  meta = with stdenv.lib; {
    description = "A bundle of NPAPI headers by Mozilla";

    homepage = https://bitbucket.org/mgorny/npapi-sdk; # see also https://github.com/mozilla/npapi-sdk
    license = licenses.bsd3;
    platforms = platforms.linux;
  };
}
