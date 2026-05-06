{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  plugincode,
  _7zz,
}:

buildPythonPackage {
  pname = "extractcode-7z";
  version = "1.0.1-unstable-2026-04-13";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "aboutcode-org";
    repo = "scancode-plugins";
    rev = "9fcc50df36afdeb7b876eea4ec46fd2d2332772f";
    hash = "sha256-uLWk3iclOkaEiaqXWu9oori2yq383xaQhJSf53ORpjU=";
  };

  patches = [
    ./0001-extractcode-7z-nix-7z-dir.patch
  ];

  propagatedBuildInputs = [ plugincode ];

  preConfigure = ''
    cd builtins/extractcode_7z_system_provided
    substituteInPlace ./src/extractcode_7z/__init__.py \
      --replace-fail "nix_7z_dir = None" "nix_7z_dir = '${_7zz}/bin'"
  '';

  # no tests
  doCheck = false;

  pythonImportsCheck = [ "extractcode_7z" ];

  meta = {
    description = "ScanCode Toolkit plugin to provide pre-built binary libraries and utilities and their locations";
    homepage = "https://github.com/aboutcode-org/scancode-plugins/tree/main/builtins/extractcode_7z_system_provided";
    license = with lib.licenses; [
      asl20
      lgpl21
    ];
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
}
