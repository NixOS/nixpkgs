{ lib
, fetchPypi
, buildPythonPackage
, psutil
, numpy
, dpkt
, cffi
, pandas
}:

buildPythonPackage rec {
  pname = "nfstream";
  version = "6.3.5";
  format = "wheel";

  src = fetchPypi {
    inherit pname version;
    format = "wheel";
    sha256 = "1wqcz4vavay56gf8nn55s67wp61rmyw8s1mzki3b3zbbzwl1zbvy";
    abi = "cp39";
    python = "cp39";
    platform = "manylinux1_x86_64";
  };

  propagatedBuildInputs = [ psutil numpy dpkt cffi pandas ];

  meta = with lib; {
    description = "Python Framework for network data analytics";
    homepage = "https://github.com/nfstream/nfstream";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ heph2 ];
  };
}

