{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  plugincode,
  _7zz,
}:

buildPythonPackage rec {
  pname = "extractcode-7z";
  version = "21.5.31";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "aboutcode-org";
    repo = "scancode-plugins";
    tag = "v${version}";
    hash = "sha256-nGgFjp1N1IM/Sm4xLJw5WiZncc369/LqNcwFJBS1EQs=";
  };

  sourceRoot = "${src.name}/builtins/extractcode_7z-linux";

  propagatedBuildInputs = [ plugincode ];

  preBuild = ''
    rm src/extractcode_7z/bin/7z{,.so}
    ln -s ${_7zz}/bin/7zz src/extractcode_7z/bin/7z
  '';

  # no tests
  doCheck = false;

  pythonImportsCheck = [ "extractcode_7z" ];

  meta = {
    description = "ScanCode Toolkit plugin to provide pre-built binary libraries and utilities and their locations";
    homepage = "https://github.com/aboutcode-org/scancode-plugins/tree/main/builtins/extractcode_7z-linux";
    license = with lib.licenses; [
      asl20
      lgpl21
    ];
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
}
