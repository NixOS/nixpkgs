{ stdenv, fetchzip, buildDunePackage, configurator, cstruct }:

buildDunePackage rec {
  pname = "io-page";
  version = "2.0.1";

  src = fetchzip {
    url = "https://github.com/mirage/${pname}/archive/${version}.tar.gz";
    sha256 = "1rw04dwrlx5hah5dkjf7d63iff82j9cifr8ifjis5pdwhgwcff8i";
  };

  buildInputs = [ configurator ];
  propagatedBuildInputs = [ cstruct ];

  meta = {
    homepage = https://github.com/mirage/io-page;
    license = stdenv.lib.licenses.isc;
    description = "IO memory page library for Mirage backends";
    maintainers = with stdenv.lib.maintainers; [ vbgl ];
  };
}
