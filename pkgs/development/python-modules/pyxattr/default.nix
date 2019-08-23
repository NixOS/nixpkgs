{ lib
, pkgs
, fetchPypi
, buildPythonPackage
}:

buildPythonPackage rec {
    pname = "pyxattr";
    version = "0.6.1";
    name = pname + "-" + version;

    src = fetchPypi {
      inherit pname version;
      sha256 = "b525843f6b51036198b3b87c4773a5093d6dec57d60c18a1f269dd7059aa16e3";
    };

    # IOError: [Errno 95] Operation not supported (expected)
    doCheck = false;

    buildInputs = with pkgs; [ attr ];

    meta = with lib; {
      description = "A Python extension module which gives access to the extended attributes for filesystem objects available in some operating systems";
      license = licenses.lgpl21Plus;
    };
}
