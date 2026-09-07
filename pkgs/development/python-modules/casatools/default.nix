{
  lib,
  buildPythonPackage,
  fetchgit,
  fetchurl,
  common-updater-scripts,
  curl,
  gnugrep,
  gnused,
  writeShellScript,
  cmake,
  pkg-config,
  swig,
  flex,
  bison,
  gfortran,
  jdk,
  setuptools,
  wheel,
  build,
  numpy,
  casaconfig,
  casacpp,
  xercesc,
  grpc,
  readline,
}:
buildPythonPackage (finalAttrs: {
  pname = "casatools";
  version = "6.7.5.18";

  src = fetchgit {
    url = "https://open-bitbucket.nrao.edu/scm/casa/casa6.git";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-75oIlaNAyu70KWSjz38LoYAvV7RJgzH/X9uBnGpriF4=";
    fetchSubmodules = false;
  };

  sourceRoot = "${finalAttrs.src.name}/casatools";

  format = "pyproject";

  nativeBuildInputs = [
    cmake
    pkg-config
    swig
    flex
    bison
    gfortran
    jdk
    grpc
    setuptools
    wheel
    build
  ];

  dontConfigure = true;

  buildInputs = [
    casacpp
    xercesc
    readline
  ];

  propagatedBuildInputs = [
    numpy
    casaconfig
  ];

  jarName = "xml-casa-assembly-1.88.jar";

  xml_jar = fetchurl {
    url = "http://casa.nrao.edu/download/devel/xml-casa/java/${finalAttrs.jarName}";
    hash = "sha256-UJCiXLXAe7Prm1qGXJ9jbuZcgKhPTSrU8qnf4C5Goxs="; # xml-jar
  };

  postPatch = ''
    mkdir -p scripts/java
    cp ${finalAttrs.xml_jar} scripts/java/${finalAttrs.jarName}
    echo "${finalAttrs.version} ${finalAttrs.version}" > version.txt
    sed -i 's/def compute_version():/def compute_version():\n    return "${finalAttrs.version}"\ndef _compute_version_orig():/' setup.py
  '';

  # Tests require a full CASA data directory and network access
  doCheck = false;

  passthru.updateScript = writeShellScript "update-casatools" ''
    set -euo pipefail
    version=$(${lib.getExe curl} -s https://pypi.org/pypi/casatools/json | ${lib.getExe gnugrep} -oP '"version"\s*:\s*"\K[^"]+' | head -1)
    ${lib.getExe' common-updater-scripts "update-source-version"} python3Packages.casatools "$version"

    # Extract the jar filename from the xml-casa script at the new tag
    jar_name=$(${lib.getExe curl} -s \
      "https://open-bitbucket.nrao.edu/rest/api/1.0/projects/CASA/repos/casa6/raw/casatools/scripts/xml-casa?at=refs/tags/$version" | \
      ${lib.getExe gnugrep} -oP '(?<=jarfile_name = ").*(?=")')
    jar_url="http://casa.nrao.edu/download/devel/xml-casa/java/$jar_name"
    jar_sri=$(nix-prefetch-url --type sha256 "$jar_url" | xargs nix hash convert --hash-algo sha256 --to sri)

    nix_file=pkgs/development/python-modules/casatools/default.nix
    ${lib.getExe gnused} -i \
      -e "s|xml-casa-assembly-[^ \"]*\.jar|$jar_name|" \
      -e "s|hash = \"sha256-.*\"; # xml-jar|hash = \"$jar_sri\"; # xml-jar|" \
      "$nix_file"
  '';

  meta = {
    description = "Python interface to core radio astronomy data processing routines";
    homepage = "https://casa.nrao.edu/";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ kiranshila ];
  };
})
