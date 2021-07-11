{ lib
, buildPythonPackage
, fetchPypi
, pkgs
, cffi
}:

buildPythonPackage rec {
  pname = "lzmaffi";
  version = "0.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0005ldzgmjhp4w5phzzdqfsnbarqqs6c7yc8rbmi3caxlsgkfl80";
  };

  buildInputs = [ pkgs.xz ];
  propagatedBuildInputs = [ cffi ];

  meta = with lib; {
    description = "Python library to seek within compressed xz files";
    homepage = "https://github.com/r3m0t/backports.lzma";
    license = licenses.bsd3;
  };
}
