{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "scheme48";
  version = "1.9.2";

  src = fetchurl {
    url = "https://s48.org/${version}/scheme48-${version}.tgz";
    sha256 = "1x4xfm3lyz2piqcw1h01vbs1iq89zq7wrsfjgh3fxnlm1slj2jcw";
  };

  # Make more reproducible by removing build user and date.
  postPatch = ''
    substituteInPlace build/build-usual-image --replace '"(made by $USER on $date)"' '""'
  '';

  meta = with lib; {
    homepage = "https://s48.org/";
    description = "Scheme 48 interpreter for R5RS";
    platforms = platforms.unix;
    license = licenses.bsd3;
    maintainers = [ maintainers.siraben ];
  };
}
