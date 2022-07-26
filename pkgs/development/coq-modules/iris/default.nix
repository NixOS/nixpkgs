{ lib, mkCoqDerivation, coq, stdpp, version ? null }:

with lib; mkCoqDerivation rec {
  pname = "iris";
  domain = "gitlab.mpi-sws.org";
  owner = "iris";
  inherit version;
  defaultVersion = with versions; switch coq.coq-version [
    { case = range "8.13" "8.16"; out = "3.6.0"; }
    { case = range "8.12" "8.14"; out = "3.5.0"; }
    { case = range "8.11" "8.13"; out = "3.4.0"; }
    { case = range "8.9"  "8.10"; out = "3.3.0"; }
  ] null;
  release."3.6.0".sha256 = "sha256:02vbq597fjxd5znzxdb54wfp36412wz2d4yash4q8yddgl1kakmj";
  release."3.5.0".sha256 = "0hh14m0anfcv65rxm982ps2vp95vk9fwrpv4br8bxd9vz0091d70";
  release."3.4.0".sha256 = "0vdc2mdqn5jjd6yz028c0c6blzrvpl0c7apx6xas7ll60136slrb";
  release."3.3.0".sha256 = "0az4gkp5m8sq0p73dlh0r7ckkzhk7zkg5bndw01bdsy5ywj0vilp";
  releaseRev = v: "iris-${v}";

  propagatedBuildInputs = [ stdpp ];

  preBuild = ''
    if [[ -f coq-lint.sh ]]
    then patchShebangs coq-lint.sh
    fi
  '';

  meta = {
    description = "The Coq development of the Iris Project";
    license = licenses.bsd3;
    maintainers = [ maintainers.vbgl ];
  };
}
