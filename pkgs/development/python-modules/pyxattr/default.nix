{ lib
, pkgs
, fetchPypi
, buildPythonPackage
}:

buildPythonPackage rec {
    pname = "pyxattr";
    version = "0.7.1";

    src = fetchPypi {
      inherit pname version;
      sha256 = "965388dd629334e850aa989a67d2360ec8257cfe8f67d07c29f980d3152f2882";
    };

    # IOError: [Errno 95] Operation not supported (expected)
    doCheck = false;

    buildInputs = with pkgs; [ attr ];

    meta = with lib; {
      description = "A Python extension module which gives access to the extended attributes for filesystem objects available in some operating systems";
      license = licenses.lgpl21Plus;
    };
}
