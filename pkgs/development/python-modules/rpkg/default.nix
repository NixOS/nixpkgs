{ stdenv, buildPythonPackage, isPy3k, fetchurl, six, pycurl, cccolutils
, koji, rpmfluff }:

buildPythonPackage rec {
  pname = "rpkg";
  version = "1.50";

  disabled = isPy3k;

  src = fetchurl {
    url = "https://releases.pagure.org/rpkg/${pname}-${version}.tar.gz";
    sha256 = "0j83bnm9snr3m1mabw2cvd2r7d6kcnkzyz7b9p65fhcc3c7s3rvv";
  };


  propagatedBuildInputs = [ pycurl koji cccolutils six rpmfluff ];

  doCheck = false; # needs /var/lib/rpm database to run tests

  meta = with stdenv.lib; {
    description = "Python library for dealing with rpm packaging";
    homepage = "https://pagure.io/fedpkg";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ ];
  };

}
