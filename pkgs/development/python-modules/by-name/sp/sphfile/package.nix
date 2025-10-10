{
  lib,
  fetchurl,
  buildPythonPackage,
  numpy,
}:

buildPythonPackage rec {
  pname = "sphfile";
  version = "1.0.3";
  format = "setuptools";

  src = fetchurl {
    url = "mirror://pypi/s/sphfile/${pname}-${version}.tar.gz";
    sha256 = "1596d801facc2b03a40a1bc67a839701f068a41597059feb82fc9378420c52c0";
  };

  propagatedBuildInputs = [ numpy ];

  doCheck = false;

  meta = with lib; {
    description = "Numpy-based NIST SPH audio-file reader";
    homepage = "https://github.com/mcfletch/sphfile";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.unix;
  };
}
