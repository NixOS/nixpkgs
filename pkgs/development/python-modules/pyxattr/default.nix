{ lib
, pkgs
, fetchPypi
, buildPythonPackage
}:

buildPythonPackage rec {
    pname = "pyxattr";
    version = "0.8.0";

    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-e/QM7FrpPdZWEocX29Joz8Ozso2VU214hndslPomeFU=";
    };

    # IOError: [Errno 95] Operation not supported (expected)
    doCheck = false;

    buildInputs = with pkgs; [ attr ];

    meta = with lib; {
      description = "A Python extension module which gives access to the extended attributes for filesystem objects available in some operating systems";
      license = licenses.lgpl21Plus;
    };
}
