{ stdenv, fetchurl, which, coq, coquelicot, flocq, mathcomp
, bignums ? null }:

let params =
  let
  v3_3 = {
    version = "3.3.0";
    uid = "37077";
    sha256 = "08fdcf3hbwqphglvwprvqzgkg0qbimpyhnqsgv3gac4y1ap0f903";
  };
  v3_4 = {
    version = "3.4.2";
    uid = "38288";
    sha256 = "00bgzbji0gkazwxhs4q8gz4ccqsa1y1r0m0ravr18ps2h8a8qva5";
  };
  v4_0 = {
    version = "4.0.0";
    uid = "38339";
    sha256 = "19sbrv7jnzyxji7irfslhr9ralc0q3gx20nymig5vqbn3vssmgpz";
  };
  in {
    "8.5" = v3_3;
    "8.6" = v3_3;
    "8.7" = v3_4;
    "8.8" = v4_0;
    "8.9" = v4_0;
    "8.10" = v4_0;
    "8.11" = v4_0;
    "8.12" = v4_0;
  };
  param = params."${coq.coq-version}";
in

stdenv.mkDerivation {
  name = "coq${coq.coq-version}-interval-${param.version}";

  src = fetchurl {
    url = "https://gforge.inria.fr/frs/download.php/file/${param.uid}/interval-${param.version}.tar.gz";
    inherit (param) sha256;
  };

  nativeBuildInputs = [ which ];
  buildInputs = [ coq ];
  propagatedBuildInputs = [ bignums coquelicot flocq ];

  configurePhase = "./configure --libdir=$out/lib/coq/${coq.coq-version}/user-contrib/Interval";
  buildPhase = "./remake";
  installPhase = "./remake install";

  meta = with stdenv.lib; {
    homepage = "http://coq-interval.gforge.inria.fr/";
    description = "Tactics for simplifying the proofs of inequalities on expressions of real numbers for the Coq proof assistant";
    license = licenses.cecill-c;
    maintainers = with maintainers; [ vbgl ];
    platforms = coq.meta.platforms;
  };

  passthru = {
    compatibleCoqVersions = stdenv.lib.flip builtins.hasAttr params;
  };

}
