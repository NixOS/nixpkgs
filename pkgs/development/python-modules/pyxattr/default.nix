{ buildPythonPackage
, fetchPypi
, lib
, pkgs
, stdenv
}:

buildPythonPackage rec {
  pname = "pyxattr";
  version = "0.8.1";
  format = "setuptools";

  # IOError: [Errno 95] Operation not supported (expected)
  doCheck = false;

  hardeningDisable = lib.optionals stdenv.isDarwin [ "strictoverflow" ];

  buildInputs = [ ] ++ lib.optionals stdenv.isLinux (with pkgs; [ attr ]);

  meta = with lib; {
    description = "A Python extension module which gives access to the extended attributes for filesystem objects available in some operating systems";
    license = licenses.lgpl21Plus;
  };
}
