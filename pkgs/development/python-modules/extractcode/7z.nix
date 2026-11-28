{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  plugincode,
  p7zip,
}:

buildPythonPackage rec {
  pname = "extractcode-7z";
  version = "1.0.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "aboutcode-org";
    repo = "scancode-plugins";
    tag = "v${version}";
    hash = "sha256-5Wp2/yst+CscTYvVhlHu6pXjCHL4A4zYrciFly9+dFQ=";
  };

  sourceRoot = "${src.name}/builtins/extractcode_7z-linux";

  propagatedBuildInputs = [ plugincode ];

  preBuild = ''
    pushd src/extractcode_7z/bin

    rm 7z 7z.so
    ln -s ${p7zip}/bin/7z 7z
    ln -s ${lib.getLib p7zip}/lib/p7zip/7z.so 7z.so

    popd
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
