{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  libarchive,
  libb2,
  bzip2,
  expat,
  lz4,
  xz,
  zlib,
  zstd,
  plugincode,
}:

buildPythonPackage rec {
  pname = "extractcode-libarchive";
  version = "21.5.31";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "aboutcode-org";
    repo = "scancode-plugins";
    tag = "v${version}";
    hash = "sha256-nGgFjp1N1IM/Sm4xLJw5WiZncc369/LqNcwFJBS1EQs=";
  };

  sourceRoot = "${src.name}/builtins/extractcode_libarchive-linux";

  preBuild = ''
    pushd src/extractcode_libarchive/lib

    rm *.so *.so.*
    ln -s ${lib.getLib libarchive}/lib/libarchive.so libarchive.so
    ln -s ${lib.getLib libb2}/lib/libb2.so libb2-la3511.so.1
    ln -s ${lib.getLib bzip2}/lib/libbz2.so libbz2-la3511.so.1.0
    ln -s ${lib.getLib expat}/lib/libexpat.so libexpat-la3511.so.1
    ln -s ${lib.getLib lz4}/lib/liblz4.so liblz4-la3511.so.1
    ln -s ${lib.getLib xz}/lib/liblzma.so liblzma-la3511.so.5
    ln -s ${lib.getLib zlib}/lib/libz.so libz-la3511.so.1
    ln -s ${lib.getLib zstd}/lib/libzstd.so libzstd-la3511.so.1

    popd
  '';

  propagatedBuildInputs = [ plugincode ];

  # no tests
  doCheck = false;

  pythonImportsCheck = [ "extractcode_libarchive" ];

  meta = {
    description = "ScanCode Toolkit plugin to provide pre-built binary libraries and utilities and their locations";
    homepage = "https://github.com/aboutcode-org/scancode-plugins/tree/main/builtins/extractcode_libarchive-linux";
    license = with lib.licenses; [
      asl20
      bsd2
    ];
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
}
