{ stdenv
, buildPythonPackage
, fetchPypi
, nose
}:

buildPythonPackage rec {
  pname = "pid";
  version = "3.0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0z9w99m1vppppj2ypgm0flslgwcjjzlr7x3m62sccavgbg1n2nwj";
  };

  buildInputs = [ nose ];

  # No tests included
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Pidfile featuring stale detection and file-locking";
    homepage = "https://github.com/trbs/pid/";
    license = licenses.asl20;
  };

}
