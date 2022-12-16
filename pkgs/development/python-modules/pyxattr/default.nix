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
      hash = "sha256-e/QM7FrpPdZWEocX29Joz8Ozso2VU214hndslPomeFU=";
    };

    buildInputs = with pkgs; [
      attr
    ];

    # IOError: [Errno 95] Operation not supported (expected)
    doCheck = false;

    meta = with lib; {
      description = "Module which gives access to the extended attributes for filesystem objects available in some operating systems";
      homepage = "https://github.com/iustin/pyxattr";
      changelog = "https://github.com/iustin/pyxattr/releases/tag/v${version}";
      license = licenses.lgpl21Plus;
      maintainers = with maintainers; [ ];
    };
}
