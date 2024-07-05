{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  plugincode,
  p7zip,
}:

buildPythonPackage rec {
  pname = "extractcode-7z";
  version = "21.5.31";

  src = fetchFromGitHub {
    owner = "nexB";
    repo = "scancode-plugins";
    rev = "v${version}";
    sha256 = "02qinla281fc6pmg5xzsrmqnf9js76f2qcbf98zq7m2dkn70as4w";
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

  meta = with lib; {
    description = "ScanCode Toolkit plugin to provide pre-built binary libraries and utilities and their locations";
    homepage = "https://github.com/nexB/scancode-plugins/tree/main/builtins/extractcode_7z-linux";
    license = with licenses; [
      asl20
      lgpl21
    ];
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
