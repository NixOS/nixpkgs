{ lib
, fetchFromGitHub
, buildPythonPackage
, plugincode
, p7zip
}:
buildPythonPackage rec {
  pname = "extractcode-7z";
  version = "21.4.4";

  src = fetchFromGitHub {
    owner = "nexB";
    repo = "scancode-plugins";
    rev = "v${version}";
    sha256 = "xnUGDMS34iMVMGo/nZwRarGzzbj3X4Rt+YHvvKpmy6A=";
  };

  sourceRoot = "source/builtins/extractcode_7z-linux";

  propagatedBuildInputs = [
    plugincode
  ];

  preBuild = ''
    pushd src/extractcode_7z/bin

    rm 7z 7z.so
    ln -s ${p7zip}/bin/7z 7z
    ln -s ${p7zip}/lib/p7zip/7z.so 7z.so

    popd
  '';

  # no tests
  doCheck = false;

  pythonImportsCheck = [
    "extractcode_7z"
  ];

  meta = with lib; {
    description = "A ScanCode Toolkit plugin to provide pre-built binary libraries and utilities and their locations";
    homepage = "https://github.com/nexB/scancode-plugins/tree/main/builtins/extractcode_7z-linux";
    license = with licenses; [ asl20 lgpl21 ];
    maintainers = teams.determinatesystems.members;
    platforms = platforms.linux;
  };
}
