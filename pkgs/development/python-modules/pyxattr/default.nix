{ lib
, pkgs
, fetchPypi
, buildPythonPackage
}:

buildPythonPackage rec {
    pname = "pyxattr";
    version = "0.6.0";
    name = pname + "-" + version;

    src = fetchPypi {
      inherit pname version;
      sha256 = "1a3fqjlgbzq5hmc3yrnxxxl8nyn3rz2kfn17svbsahaq4gj0xl09";
    };

    # IOError: [Errno 95] Operation not supported (expected)
    doCheck = false;

    buildInputs = with pkgs; [ attr ];

    meta = with lib; {
      description = "A Python extension module which gives access to the extended attributes for filesystem objects available in some operating systems";
      license = licenses.lgpl21Plus;
    };
}
