{ autoPatchelfHook
, buildPythonPackage
, cmake
, cython
, fetchFromGitHub
, h3
, lib
, numpy
, pytestCheckHook
, scikit-build
, stdenv
}:

buildPythonPackage rec {
  pname = "h3";
  version = "3.7.6";
  format = "setuptools";

  # pypi version does not include tests
  src = fetchFromGitHub {
    owner = "uber";
    repo = "h3-py";
    rev = "refs/tags/v${version}";
    hash = "sha256-QNiuiHJ4IMxpi39iobPSSlYUUj5oxpxO4B2+HXVQ/Zk=";
  };

  dontConfigure = true;

  nativeCheckInputs = [ pytestCheckHook ];

  nativeBuildInputs = [
    scikit-build cmake cython
  ] ++ lib.optionals stdenv.hostPlatform.isLinux [
    # On Linux the .so files ends up referring to libh3.so instead of the full
    # Nix store path. I'm not sure why this is happening! On Darwin it works
    # fine.
    autoPatchelfHook
  ];

  # This is not needed per-se, it's only added for autoPatchelfHook to work
  # correctly. See the note above ^^
  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ h3 ];

  propagatedBuildInputs = [ numpy ];

  # The following prePatch replaces the h3lib compilation with using the h3 packaged in nixpkgs.
  #
  # - Remove the h3lib submodule.
  # - Patch CMakeLists to avoid building h3lib, and use h3 instead.
  prePatch =
    let
      cmakeCommands = ''
        include_directories(${lib.getDev h3}/include/h3)
        link_directories(${h3}/lib)
      '';
    in ''
      rm -r src/h3lib
      substituteInPlace CMakeLists.txt --replace "add_subdirectory(src/h3lib)" "${cmakeCommands}"
    '';

  # Extra check to make sure we can import it from Python
  pythonImportsCheck = [ "h3" ];

  meta = with lib; {
    homepage = "https://github.com/uber/h3-py";
    description = "Hierarchical hexagonal geospatial indexing system";
    license = licenses.asl20;
    maintainers = [ maintainers.kalbasit ];
  };
}
