{ lib
, pkgs
, fetchPypi
, buildPythonPackage
}:

buildPythonPackage rec {
    pname = "pyxattr";
    version = "0.7.2";

    src = fetchPypi {
      inherit pname version;
      sha256 = "68477027e6d3310669f98aaef15393bfcd9b2823d7a7f00a6f1d91a3c971ae64";
    };

    # IOError: [Errno 95] Operation not supported (expected)
    doCheck = false;

    buildInputs = with pkgs; [ attr ];

    meta = with lib; {
      description = "A Python extension module which gives access to the extended attributes for filesystem objects available in some operating systems";
      license = licenses.lgpl21Plus;
    };
}
