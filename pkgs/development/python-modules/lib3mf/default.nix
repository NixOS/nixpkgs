{
  lib,
  pkgs,
  stdenv,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
}:

let
  version = "2.4.1";
  soext = stdenv.hostPlatform.extensions.sharedLibrary;
  lib3mf-lib = pkgs.lib3mf;

in
assert version == lib3mf-lib.version;

buildPythonPackage {
  pname = "lib3mf";
  inherit version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "3MFConsortium";
    repo = "lib3mf_python";
    rev = "f460ae8588fa2ccc4afd247d5a57778536e47ec3"; # untagged 2.4.1
    hash = "sha256-dVFbHin8rGxCWhrcTvL+YqfU/k/9Pu773nlC1l7wPHQ=";
  };

  build-system = [ setuptools ];

  postPatch = ''
    echo "include lib3mf/lib3mf${soext}" > MANIFEST.in
  '';

  pythonImportsCheck = [ "lib3mf" ];

  prePatch = ''
    rm lib3mf/lib3mf.{dll,dylib,so}
    cp -L ${lib.getLib lib3mf-lib}/lib/lib3mf${soext} lib3mf/
  '';

  meta = {
    description = "Python bindings to lib3mf";
    homepage = "https://github.com/3MFConsortium/lib3mf_python";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ tnytown ];
  };
}
